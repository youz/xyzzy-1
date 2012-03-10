#include <windows.h>
#include <initguid.h>

DEFINE_GUID (CLSID_CActiveIMM, 0x4955dd33, 0xb159, 0x11d0,
             0x8f, 0xcf, 0x00, 0xaa, 0x00, 0x6b, 0xcc, 0x59);
DEFINE_GUID (IID_IActiveIMMApp, 0x08c0e040, 0x62d1, 0x11d1,
             0x93, 0x26, 0x00, 0x60, 0xb0, 0x67, 0xb8, 0x6e);
DEFINE_GUID (IID_IActiveIMMIME, 0x08c03411, 0xf96b, 0x11d0,
             0xa4, 0x75, 0x00, 0xaa, 0x00, 0x6b, 0xcc, 0x59);
DEFINE_GUID (IID_IActiveIMMMessagePumpOwner, 0xb5cf2cfa, 0x8aeb, 0x11d1,
             0x93, 0x64, 0x00, 0x60, 0xb0, 0x67, 0xb8, 0x6e);
DEFINE_GUID (IID_IActiveIMMRegistrar, 0xb3458082, 0xbd00, 0x11d1,
             0x93, 0x9b, 0x00, 0x60, 0xb0, 0x67, 0xb8, 0x6e);

DEFINE_GUID (IID_IProvideClassInfo, 0xb196b283, 0xbab4, 0x101a,
             0xb6, 0x9c, 0x00, 0xaa, 0x00, 0x34, 0x1d, 0x07);
DEFINE_GUID (IID_IProvideClassInfo2, 0xa6bc3ac0, 0xdbaa, 0x11ce,
             0x9d, 0xe3, 0x00, 0xaa, 0x00, 0x4b, 0xb8, 0x51);
DEFINE_GUID (IID_IConnectionPointContainer, 0xb196b284, 0xbab4, 0x101a,
             0xb6, 0x9c, 0x00, 0xaa, 0x00, 0x34, 0x1d, 0x07);