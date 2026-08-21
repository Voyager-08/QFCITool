# QFCITool

基于 Qt 6 / QML 的 FCITool UI 复刻版（源项目：`D:\Code\FCITool`，GTK4）。

## 环境

- Qt 6.5.3 (mingw_64)
- MinGW-w64 g++ 11.2 (`D:\QT\QT_x\Tools\mingw1120_64`)
- CMake 3.21+

## 构建

```powershell
cmake -B build -G "MinGW Makefiles" ^
  -DCMAKE_PREFIX_PATH="D:/QT/QT_x/6.5.3/mingw_64" ^
  -DCMAKE_C_COMPILER="D:/QT/QT_x/Tools/mingw1120_64/bin/gcc.exe" ^
  -DCMAKE_CXX_COMPILER="D:/QT/QT_x/Tools/mingw1120_64/bin/g++.exe" ^
  -DCMAKE_BUILD_TYPE=Release

cmake --build build -j
```

运行：

```powershell
.\build\QFCITool.exe
```

## UI 对应关系

| 原 GTK 界面 | QML |
|---|---|
| 顶栏标题 + USB 按钮 | `TopBar.qml` |
| USB 配置 Popover | `UsbConfigPopup.qml` |
| 左侧导航 | `Sidebar.qml` |
| 控制栏（使能/拖动/失能/回零） | `ControlBar.qml` |
| 状态监控 | `MonitorView.qml` |
| 数字孪生 / 电机 / 设备 | 占位页（可后续接入） |

当前 USB / 遥测为演示数据，便于先对齐界面；后续可对接真实串口与 SDK。
