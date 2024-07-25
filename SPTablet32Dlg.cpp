
// SPTablet32Dlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "SPTablet32App.h"
#include "SPTablet32Dlg.h"
#include "afxdialogex.h"
#include "SPTablet32API.h"
#include <algorithm>

#define WM_SHOW_TASK 0x400
#define EXIT_MENU_ITEM_ID 0x300
#define UM_NOTIFYICONDATA 0x200
#define ID_REFRESH_TIMER 0x100
#ifdef _DEBUG
#define new DEBUG_NEW
#endif
static void GetSerialPorts(std::vector<int>& ports, DWORD maxlen = 1ULL << 20)
{
	//Make sure we clear out any elements which may already be in the array
	ports.clear();
	//Use QueryDosDevice to look for all devices of the form COMx. This is a better
	//solution as it means that no ports have to be opened at all.
	TCHAR* szDevices = new TCHAR[maxlen];
	if (szDevices != nullptr) {
		memset(szDevices, 0, maxlen * sizeof(TCHAR));

		DWORD dwChars = QueryDosDevice(NULL, szDevices, maxlen);
		if (dwChars)
		{
			int i = 0;

			for (; szDevices != nullptr;)
			{
				//Get the current device name
				TCHAR* pszCurrentDevice = &szDevices[i];

				//If it looks like "COMX" then
				//add it to the array which will be returned
				size_t nLen = _tcslen(pszCurrentDevice);
				if (nLen > 3 && _tcsnicmp(pszCurrentDevice, _T("COM"), 3) == 0)
				{
					//Work out the port number
					int nPort = _ttoi(&pszCurrentDevice[3]);
					ports.push_back(nPort);
				}

				// Go to next NULL character
				while (szDevices[i] != _T('\0'))
					i++;

				// Bump pointer to the next string
				i++;

				// The list is double-NULL terminated, so if the character is
				// now NULL, we're at the end
				if (szDevices[i] == _T('\0'))
					break;
			}
		}
		delete[] szDevices;
	}
	std::sort(ports.begin(), ports.end());
}


// 用于应用程序“关于”菜单项的 CAboutDlg 对话框

class CAboutDlg : public CDialogEx
{
public:
	CAboutDlg();

	// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_ABOUTBOX };
#endif

protected:
	virtual void DoDataExchange(CDataExchange* pDX);    // DDX/DDV 支持

	// 实现
protected:
	DECLARE_MESSAGE_MAP()
};

CAboutDlg::CAboutDlg() : CDialogEx(IDD_ABOUTBOX)
{
}

void CAboutDlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
}

BEGIN_MESSAGE_MAP(CAboutDlg, CDialogEx)
END_MESSAGE_MAP()


// CSPTablet32Dlg 对话框



CSPTablet32Dlg::CSPTablet32Dlg(CWnd* pParent /*=nullptr*/)
	: CDialogEx(IDD_SPTABLET32_DIALOG, pParent)
	, Port()
	, Buffer()
	, m_NotifyIconData()
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSPTablet32Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_PORTS_LIST, PortsList);
	DDX_Control(pDX, IDC_BUTTON_START, ButtonStart);
	DDX_Control(pDX, IDC_CHECK_USE_STANDARD_MOUSE, UseStandardMouse);
}

void CSPTablet32Dlg::onReadEvent(const char* portName, unsigned int readBufferLen)
{
	if (this->Port.isOpen() && readBufferLen > 0)
	{
		unsigned char* data = new unsigned char[readBufferLen];

		if (data != nullptr)
		{
			int recLen = this->Port.readData(data, readBufferLen);
			if (recLen > 0) {
				this->Buffer += (char*)data;
				size_t p = 0;
				while (this->Buffer.size() >= PacketLength
					&& ((size_t)-1) != (p = this->onProcessPacket(this->Buffer.c_str(), this->Buffer.size())))
				{
					this->Buffer = this->Buffer.substr(p);
					if (this->Buffer.size() == 0) break;
					if (this->Buffer.size() >= PacketLength) {
						this->Buffer = this->Buffer.substr(PacketLength);
					}
				}
			}

			delete[] data;
		}
	}
}

size_t CSPTablet32Dlg::onProcessPacket(const char* buffer, size_t length)
{

	//microsoft mouse protocol :

	// 7BITS
	// BYTE 0   0  1  L  R  Y7 Y6 X7 X6
	// BYTE 1   0  0  X5 X4 X3 X2 X1 X0
	// BYTE 2   0  0  Y5 Y4 Y3 Y2 Y1 Y0


	size_t i = 0;
	for (i = 0; i < length - 2; i++) {
		char bc = buffer[i + 0];
		char bx = buffer[i + 1];
		char by = buffer[i + 2];
		if ((bc & 0b11000000) == 0b01000000
			&& (bx & 0b11000000) == 0b00000000
			&& (by & 0b11000000) == 0b00000000
			)
		{
			bool left = (bc & 0b00100000) != 0;
			bool right = (bc & 0b00010000) != 0;

			int dx = (char)((bx & 0b01111111) | (bc & 0b00000011) << 6);
			int dy = (char)((by & 0b01111111) | (bc & 0b00001100) << 4);
			
			onSendInput(dx, dy, left, right);
			return i;
		}
	}

	return (size_t)(-1);
}

UINT CSPTablet32Dlg::onSendInput(int dx, int dy, bool left, bool right)
{
	UINT ret = 0;
	INPUT input = { 0 };
	input.type = INPUT_MOUSE;
	input.mi.mouseData = 0;

	//if (dx != last_x || dy != last_y) 
	{
		input.mi.dwFlags |= MOUSEEVENTF_MOVE;
	}

	if (!last_left && left)
		input.mi.dwFlags |= MOUSEEVENTF_LEFTDOWN;
	else if (last_left && !left)
		input.mi.dwFlags |= MOUSEEVENTF_LEFTUP;
	last_left = left;

	if (!last_right && right)
		input.mi.dwFlags |= MOUSEEVENTF_RIGHTDOWN;
	else if (last_right && !right)
		input.mi.dwFlags |= MOUSEEVENTF_RIGHTUP;
	last_right = right;

	input.mi.dx = dx;
	input.mi.dy = dy;
	//static int index = 0;
	//CString text;
	//text.Format(_T("index = %08d, dx=%08d,dy=%08d,left=%d,right=%d\r\n"), index++, dx, dy, left, right);
	//OutputDebugString(text);

	ret =SendInput(1, &input, sizeof(INPUT));
	return ret;
}

void CSPTablet32Dlg::UpdateCommPortsList()
{
	std::vector<int> listed_ports;
	std::vector<int> found_ports;
	GetSerialPorts(found_ports);
	for (int i = 0; i < this->PortsList.GetCount(); i++) {
		DWORD_PTR p = this->PortsList.GetItemData(i);
		listed_ports.push_back((int)p);
	}
	std::sort(listed_ports.begin(), listed_ports.end());
	bool eq = found_ports.size() > 0
		&& listed_ports.size()
		== found_ports.size()
		&& std::equal(
			std::begin(listed_ports),
			std::end(listed_ports),
			std::begin(found_ports));
	if (!eq) {
		this->PortsList.SetCurSel(-1);
		this->PortsList.Clear();
		for (size_t i = 0; i < found_ports.size(); i++) {
			CString com_name;
			int com_number = found_ports[i];
			com_name.Format(_T("COM%d"), com_number);
			int index = this->PortsList.AddString(com_name);
			if (index >= 0) {
				this->PortsList.SetItemData(index, com_number);
			}
		}
	}

	if (this->PortsList.GetCount() > 0
		&& this->PortsList.GetCurSel() == -1) {
		int index = 0;
		CString text = theApp.GetProfileString(_T("Config"), _T("COMPort"), _T(""));
		index = !text.IsEmpty() ?
			this->PortsList.FindStringExact(-1, text) : 0;
		this->PortsList.SetCurSel(index >= 0 ? index : 0);
	}
	if (!this->Port.isOpen()) {
		//do not enable window if no port at all
		this->PortsList.EnableWindow(this->PortsList.GetCount() > 0);
	}
}


tablet_status CSPTablet32Dlg::DoActivate(CString& COM)
{
	tablet_status status = unknown;

	if (this->PortsList.GetCount() > 0)
	{
		int SelIndex = this->PortsList.GetCurSel();
		if (SelIndex < 0) SelIndex = 0;
		INT_PTR PortNumber = this->PortsList.GetItemData(SelIndex);

		COM.Format(_T("COM%d"), (int)PortNumber);
		theApp.WriteProfileString(_T("Config"), _T("COMPort"), COM);

		CString COMPath = _T("\\\\.\\") + COM;

		status = setup_tablet(COMPath, microsoft_mouse_protocol);;
	}
	return status;
}

BEGIN_MESSAGE_MAP(CSPTablet32Dlg, CDialogEx)
	ON_MESSAGE(WM_SHOW_TASK, OnShowTask)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_TEST, &CSPTablet32Dlg::OnBnClickedButtonStart)
	ON_WM_TIMER()
	ON_BN_CLICKED(IDCANCEL, &CSPTablet32Dlg::OnBnClickedCancel)
	ON_BN_CLICKED(IDC_BUTTON_HIDE, &CSPTablet32Dlg::OnBnClickedButtonHide)
	ON_WM_CLOSE()
	ON_WM_DESTROY()
	ON_BN_CLICKED(IDC_CHECK_USE_STANDARD_MOUSE, &CSPTablet32Dlg::OnBnClickedCheckUseStandardMouse)
	ON_BN_CLICKED(IDC_BUTTON_ACTIVATE, &CSPTablet32Dlg::OnBnClickedButtonActivate)
END_MESSAGE_MAP()


// CSPTablet32Dlg 消息处理程序

BOOL CSPTablet32Dlg::OnInitDialog()
{
	CDialogEx::OnInitDialog();

	// 将“关于...”菜单项添加到系统菜单中。

	// IDM_ABOUTBOX 必须在系统命令范围内。
	ASSERT((IDM_ABOUTBOX & 0xFFF0) == IDM_ABOUTBOX);
	ASSERT(IDM_ABOUTBOX < 0xF000);

	CMenu* pSysMenu = GetSystemMenu(FALSE);
	if (pSysMenu != nullptr)
	{
		BOOL bNameValid;
		CString strAboutMenu;
		bNameValid = strAboutMenu.LoadString(IDS_ABOUTBOX);
		ASSERT(bNameValid);
		if (!strAboutMenu.IsEmpty())
		{
			pSysMenu->AppendMenu(MF_SEPARATOR);
			pSysMenu->AppendMenu(MF_STRING, IDM_ABOUTBOX, strAboutMenu);
		}
	}

	// 设置此对话框的图标。  当应用程序主窗口不是对话框时，框架将自动
	//  执行此操作
	SetIcon(m_hIcon, TRUE);			// 设置大图标
	SetIcon(m_hIcon, FALSE);		// 设置小图标

	this->UpdateCommPortsList();
	this->SetTimer(ID_REFRESH_TIMER, 1000, NULL);

	m_NotifyIconData.cbSize = sizeof(m_NotifyIconData);
	m_NotifyIconData.hWnd = m_hWnd;
	m_NotifyIconData.uID = UM_NOTIFYICONDATA;
	m_NotifyIconData.uFlags = NIF_MESSAGE | NIF_ICON | NIF_TIP;
	m_NotifyIconData.uCallbackMessage = WM_SHOW_TASK;
	m_NotifyIconData.hIcon = m_hIcon;
	//这里的wcscpy_s为宽字符集函数，对应的C函数为strcpy_s
	wcscpy_s(m_NotifyIconData.szTip, 64, _T("SPTable32"));

	//调用此函数来显示托盘
	Shell_NotifyIcon(NIM_ADD, &m_NotifyIconData);
	this->UseStandardMouse.SetCheck(theApp.GetProfileInt(_T("Config"), _T("UseStandardMouse"), 0));

	return TRUE;  // 除非将焦点设置到控件，否则返回 TRUE
}

void CSPTablet32Dlg::OnSysCommand(UINT nID, LPARAM lParam)
{
	if ((nID & 0xFFF0) == IDM_ABOUTBOX)
	{
		CAboutDlg dlgAbout;
		dlgAbout.DoModal();
	}
	else
	{
		CDialogEx::OnSysCommand(nID, lParam);
	}
}

// 如果向对话框添加最小化按钮，则需要下面的代码
//  来绘制该图标。  对于使用文档/视图模型的 MFC 应用程序，
//  这将由框架自动完成。

void CSPTablet32Dlg::OnPaint()
{
	if (IsIconic())
	{
		CPaintDC dc(this); // 用于绘制的设备上下文

		SendMessage(WM_ICONERASEBKGND, reinterpret_cast<WPARAM>(dc.GetSafeHdc()), 0);

		// 使图标在工作区矩形中居中
		int cxIcon = GetSystemMetrics(SM_CXICON);
		int cyIcon = GetSystemMetrics(SM_CYICON);
		CRect rect;
		GetClientRect(&rect);
		int x = (rect.Width() - cxIcon + 1) / 2;
		int y = (rect.Height() - cyIcon + 1) / 2;

		// 绘制图标
		dc.DrawIcon(x, y, m_hIcon);
	}
	else
	{
		CDialogEx::OnPaint();
	}
}

//当用户拖动最小化窗口时系统调用此函数取得光标
//显示。
HCURSOR CSPTablet32Dlg::OnQueryDragIcon()
{
	return static_cast<HCURSOR>(m_hIcon);
}

LRESULT CSPTablet32Dlg::OnShowTask(WPARAM wParam, LPARAM lParam)
{
	if (wParam == UM_NOTIFYICONDATA)
	{
		switch (lParam) {
		case WM_LBUTTONDOWN:
		{
			this->ShowWindow(SW_SHOW);
		}
		break;
		case WM_RBUTTONDOWN:
		{
			POINT p = { 0 };

			::GetCursorPos(&p); // 得到鼠标位置

			CMenu menu;

			menu.CreatePopupMenu();
			menu.AppendMenu(MF_STRING, EXIT_MENU_ITEM_ID, _T("关闭(&X)"));

			if (menu.TrackPopupMenu(TPM_LEFTALIGN, p.x, p.y, this)) {

			}

			HMENU hmenu = menu.Detach();

			menu.DestroyMenu();
		}
		break;
		}
	}
	return LRESULT();
}

void CSPTablet32Dlg::OnBnClickedButtonStart()
{
	if (this->Port.isOpen()) {
		this->Port.clearError();
		this->Port.flushBuffers();
		this->Port.close();
		this->PortsList.EnableWindow(TRUE);
		this->ButtonStart.SetWindowText(_T("启动"));
	}
	else 
	{
		CString COM;
		tablet_status status = unknown;
		if (this->UseStandardMouse.GetCheck()==0) {
			status = DoActivate(COM);
		}

		if (status <= 0)
		{
			MessageBox(_T("SPTablet32 未能开启鼠标模拟功能!"), _T("SPTablet32"));
		}
		else
		{
			this->Port.connectReadEvent(this);
			//1200,8,N,1
			this->Port.init(
				(CStringA)COM,
				1200,
				itas109::Parity(itas109::Parity::ParityNone),
				itas109::DataBits(itas109::DataBits::DataBits7),
				itas109::StopBits(itas109::StopBits::StopOne),
				itas109::FlowControl::FlowHardware, 48);
			if (this->Port.open())
			{
				this->PortsList.EnableWindow(FALSE);
				this->ButtonStart.SetWindowText(_T("停止"));
			}
			else {
				MessageBox(_T("SPTablet32 无法启动!"), _T("SPTablet32"));
			}
		}
	}
}

BOOL CSPTablet32Dlg::OnCommand(WPARAM wParam, LPARAM lParam)
{
	if (wParam == EXIT_MENU_ITEM_ID) {
		this->DestroyWindow();
	}
	return CDialogEx::OnCommand(wParam,lParam);
}


void CSPTablet32Dlg::OnTimer(UINT_PTR nIDEvent)
{
	switch (nIDEvent) {
	case ID_REFRESH_TIMER:
		this->UpdateCommPortsList();
		break;

	}

	__super::OnTimer(nIDEvent);
}


void CSPTablet32Dlg::OnBnClickedCancel()
{
}


void CSPTablet32Dlg::OnBnClickedButtonHide()
{
	this->ShowWindow(SW_HIDE);
}


void CSPTablet32Dlg::OnClose()
{
	this->ShowWindow(SW_HIDE);
	__super::OnClose();
}


void CSPTablet32Dlg::OnDestroy()
{
	Shell_NotifyIcon(NIM_DELETE, &m_NotifyIconData);

	__super::OnDestroy();
}


void CSPTablet32Dlg::OnBnClickedCheckUseStandardMouse()
{
	theApp.WriteProfileInt(_T("Config"), _T("UseStandardMouse"), this->UseStandardMouse.GetCheck());
}


void CSPTablet32Dlg::OnBnClickedButtonActivate()
{
	CString COM;
	tablet_status status = this->DoActivate(COM);
	if (status <= 0)
	{
		MessageBox(_T("SPTablet32 未能开启鼠标模拟功能!"), _T("SPTablet32"));
	}
	else {
		MessageBox(_T("SPTablet32 已经开启鼠标模拟功能，请重启操作系统以使用!"), _T("SPTablet32"));

	}
}
