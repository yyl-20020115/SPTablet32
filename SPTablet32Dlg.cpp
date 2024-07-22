
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
{
	m_hIcon = AfxGetApp()->LoadIcon(IDR_MAINFRAME);
}

void CSPTablet32Dlg::DoDataExchange(CDataExchange* pDX)
{
	CDialogEx::DoDataExchange(pDX);
	DDX_Control(pDX, IDC_COMBO_PORTS_LIST, PortsList);
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
				size_t parts = this->Buffer.size() / PacketLength;
				size_t reminder = this->Buffer.size() % PacketLength;
				if (reminder == 0) {
					this->Buffer.clear();
				}
				else {
					std::vector<unsigned char> NewBuffer(this->Buffer.begin() + parts * PacketLength, this->Buffer.end());
					this->Buffer = NewBuffer;
				}
				this->Buffer.insert(this->Buffer.end(), data, data + recLen);
				this->onProcessPackets(this->Buffer);

			}

			delete[] data;
		}
	}
}

void CSPTablet32Dlg::onProcessPackets(const std::vector<unsigned char>& Buffer)
{
	size_t _bmax = Buffer.size();
	size_t _count = _bmax / PacketLength;
	size_t _reminder = _bmax % PacketLength;

	if (_reminder > 0) {
		_bmax -= _reminder;
	}
	UINT ret = 0;
	INPUT* inputs = new INPUT[_count];
	if (inputs != nullptr) {
		for (size_t i = 0; i < _bmax; i += PacketLength) {
			unsigned char btx = Buffer[i + 0];
			unsigned char bx0 = Buffer[i + 1];
			unsigned char by0 = Buffer[i + 2];
			unsigned char bx1 = Buffer[i + 3];
			unsigned char by1 = Buffer[i + 4];

			bool left = (btx & 0b00000100) != 0;
			bool middle = (btx & 0b00000010) != 0;
			bool right = (btx & 0b00000001) != 0;

			int dx = ((int)bx0) | ((int)bx1) << 8;
			int dy = ((int)by0) | ((int)by1) << 8;

			inputs[i].type = INPUT_MOUSE;
			inputs[0].mi.mouseData = 0;

			if (dx != last_x || dy != last_y) {
				inputs[i].mi.dwFlags |= MOUSEEVENTF_MOVE;
			}

			if (!last_left && left)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_LEFTDOWN;
			else if (last_left && !left)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_LEFTUP;
			last_left = left;


			if (!last_middle && middle)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_MIDDLEDOWN;
			else if (last_middle && !middle)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_MIDDLEUP;
			last_middle = middle;
			if (!last_right && right)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_RIGHTDOWN;
			else if (last_right && !right)
				inputs[i].mi.dwFlags |= MOUSEEVENTF_RIGHTUP;
			last_right = right;

			inputs[i].mi.dx = dx;
			inputs[i].mi.dy = dy;

		}

		ret = SendInput(_count, inputs, sizeof(INPUT));

		delete[] inputs;


	}

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
	CString COM = _T("COM2");
	CString COMPath = _T("\\\\.\\") + COM;

	tablet_status status = setup_tablet(COMPath, mouse_system_protocol);
	if (status > 0) {
		if (this->Port.isOpen()) {
			this->Port.close();
			this->Port.disconnectReadEvent();
		}
		this->Port.connectReadEvent(this);
		//this->Port.setReadIntervalTimeout(5);
		this->Port.init(
			(CStringA)COM,
			9600,
			itas109::Parity(itas109::Parity::ParityOdd),
			itas109::DataBits(itas109::DataBits::DataBits8),
			itas109::StopBits(itas109::StopBits::StopOne));
		if (this->Port.open())
		{
			this->PortsList.EnableWindow(FALSE);
		}

	}
}
