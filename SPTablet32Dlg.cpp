
// SPTablet32Dlg.cpp: 实现文件
//

#include "pch.h"
#include "framework.h"
#include "SPTablet32App.h"
#include "SPTablet32Dlg.h"
#include "afxdialogex.h"
#include "SPTablet32API.h"
#ifdef _DEBUG
#define new DEBUG_NEW
#endif


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
	, Mutex()
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSPTablet32Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_PORTS_LIST, PortsList);
	DDX_Control(pDX, IDC_BUTTON_START, ButtonStart);
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
				this->Mutex.lock();
				{
					this->Buffer += (char*)data;
					size_t p = 0;
					while (((size_t)-1) != (p = this->onProcessPacket(this->Buffer.c_str(), this->Buffer.size())))
					{
						this->Buffer = this->Buffer.substr(p);
						if (this->Buffer.size() == 0) break;
						if (this->Buffer.size() >= PacketLength) {
							this->Buffer = this->Buffer.substr(PacketLength);
						}
					}
				}
				this->Mutex.unlock();
			}

			delete[] data;
		}
	}
}

size_t CSPTablet32Dlg::onProcessPacket(const char* buffer, size_t length)
{

	//microsoft mouse protocol :
	//BYTE 0   1  1  L  R  Y7 Y6 X7 X6
	//BYTE 1   0  0  X5 X4 X3 X2 X1 X0
	//BYTE 2   0  0  Y5 Y4 Y3 Y2 Y1 Y0
	size_t i = 0;
	for (i = 0; i < length - 2; i++) {
		char bc = buffer[i + 0];
		char bx = buffer[i + 1];
		char by = buffer[i + 2];
		if ((bc & 0b11000000) == 0b11000000
			&& (bx & 0b11000000) == 0b10000000
			&& (by & 0b11000000) == 0b10000000
			)
		{
			//empty frame
			if (bx == (char)0x80 && by == (char)0x80) return i;

			bool left =  (bc & 0b00100000) != 0;
			bool right = (bc & 0b00010000) != 0;

			int dx = (char)(bx | (bc & 0b00000011) << 6);
			int dy = (char)(by | (bc & 0b00001100) << 4);

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
	static int index = 0;
	CString text;
	text.Format(_T("index = %08d, dx=%08d,dy=%08d,left=%d,right=%d\r\n"),index++, dx, dy, left, right);
	OutputDebugString(text);

	//ret =SendInput(1, &input, sizeof(INPUT));
	return ret;
}

BEGIN_MESSAGE_MAP(CSPTablet32Dlg, CDialogEx)
	ON_WM_SYSCOMMAND()
	ON_WM_PAINT()
	ON_WM_QUERYDRAGICON()
	ON_BN_CLICKED(IDC_BUTTON_TEST, &CSPTablet32Dlg::OnBnClickedButtonStart)
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

	// TODO: 在此添加额外的初始化代码

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

void CSPTablet32Dlg::OnBnClickedButtonStart()
{
	if (this->Port.isOpen()) {
		this->ButtonStart.SetWindowText(_T("开始"));
		this->Port.close();
		this->Port.disconnectReadEvent();
		this->PortsList.EnableWindow(TRUE);
	}
	else
	{
		CString COM = _T("COM2");
		CString COMPath = _T("\\\\.\\") + COM;

		tablet_status status = setup_tablet(COMPath, microsoft_mouse_protocol);
		if (status < 0) {
			MessageBox(_T("SPTablet is NOT initialized as a mouse!"), _T("SPTablet"));
		}
		if (status > 0)
		{
			this->Port.connectReadEvent(this);
			//1200,8,N,1
			this->Port.init(
				(CStringA)COM,
				1200,
				itas109::Parity(itas109::Parity::ParityNone),
				itas109::DataBits(itas109::DataBits::DataBits8),
				itas109::StopBits(itas109::StopBits::StopOne),
				itas109::FlowControl::FlowHardware, 48);
			if (this->Port.open())
			{
				this->ButtonStart.SetWindowText(_T("停止"));

				this->PortsList.EnableWindow(FALSE);
			}

		}
	}
}
