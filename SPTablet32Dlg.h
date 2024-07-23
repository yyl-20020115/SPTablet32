
// SPTablet32Dlg.h: 头文件
//

#pragma once
#include <CSerialPort/SerialPort.h>
#include <vector>
#include <string>
#include <mutex>
// CSPTablet32Dlg 对话框
class CSPTablet32Dlg : public CDialogEx, public itas109::CSerialPortListener
{
public:
	static const size_t PacketLength = 3;
// 构造
public:
	CSPTablet32Dlg(CWnd* pParent = nullptr);	// 标准构造函数

// 对话框数据
#ifdef AFX_DESIGN_TIME
	enum { IDD = IDD_SPTABLET32_DIALOG };
#endif

	protected:
	virtual void DoDataExchange(CDataExchange* pDX);	// DDX/DDV 支持
public:
	virtual void onReadEvent(const char* portName, unsigned int readBufferLen);
	virtual size_t onProcessPacket(const char* Buffer, size_t length);
protected:
	UINT onSendInput(int dx, int dy, bool left, bool right);

	void UpdateCommPortsList();

// 实现
protected:
	HICON m_hIcon;
	itas109::CSerialPort Port;
	std::string Buffer;
	NOTIFYICONDATA m_NotifyIconData;
	// 生成的消息映射函数
	virtual BOOL OnInitDialog();
	afx_msg void OnSysCommand(UINT nID, LPARAM lParam);
	afx_msg void OnPaint();
	afx_msg HCURSOR OnQueryDragIcon();
	LRESULT OnShowTask(WPARAM wParam, LPARAM lParam);
	DECLARE_MESSAGE_MAP()
public:
	afx_msg void OnBnClickedButtonStart();
	CComboBox PortsList;

	bool last_left = false;
	bool last_middle = false;
	bool last_right = false;
	int last_x = 0;
	int last_y = 0;

	afx_msg void OnTimer(UINT_PTR nIDEvent);
	afx_msg void OnBnClickedCancel();
	afx_msg void OnBnClickedButtonHide();
	afx_msg void OnClose();
	afx_msg void OnDestroy();
	CButton ButtonStart;
};
