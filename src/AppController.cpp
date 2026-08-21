#include "AppController.h"

#include <QFileInfo>
#include <QtMath>
#include <cmath>

AppController::AppController(QObject *parent)
    : QObject(parent)
{
    m_ports = {
        QStringLiteral("COM3"),
        QStringLiteral("COM5"),
        QStringLiteral("COM7")
    };

    const QStringList names = {
        QStringLiteral("J1"), QStringLiteral("J2"), QStringLiteral("J3"),
        QStringLiteral("J4"), QStringLiteral("J5"), QStringLiteral("J6"),
        QStringLiteral("夹爪")
    };
    for (const auto &name : names)
        m_joints.append(makeJoint(name, 0.0, 0.0, -100.0));

    connect(&m_timer, &QTimer::timeout, this, &AppController::tickTelemetry);
    m_timer.start(100);

    connect(&m_flashTimer, &QTimer::timeout, this, [this]() {
        m_flashProgress = qMin(1.0, m_flashProgress + 0.04);
        emit flashProgressChanged();
        if (m_flashProgress >= 1.0) {
            m_flashTimer.stop();
            m_flashing = false;
            emit flashingChanged();
        }
    });

    updateButtonState();
}

QString AppController::connectionStatus() const
{
    return m_connected ? QStringLiteral("● Connected") : QStringLiteral("○ Disconnected");
}

QString AppController::busStatusText() const
{
    if (!m_connected)
        return QStringLiteral("等待连接");
    return m_busHealthy ? QStringLiteral("健康") : QStringLiteral("异常");
}

void AppController::refreshPorts()
{
    // UI mock: keep a stable demo list; real port enum can replace this later.
    emit portsChanged();
}

void AppController::toggleConnection(const QString &portName)
{
    if (m_connected) {
        m_connected = false;
        m_connectedPort.clear();
        m_mode = Mode::Damp;
        m_uptimeSeconds = 0;
        m_busHealthy = false;
        m_poseText.clear();
        resetDeviceInfo();
        updateButtonState();
        emit connectedChanged();
        emit telemetryChanged();
        return;
    }

    if (portName.isEmpty())
        return;

    m_connected = true;
    m_connectedPort = portName;
    m_boardName = portName;
    m_firmwareVersion = QStringLiteral("v1.2.0");
    m_protocolVersion = QStringLiteral("v1.0.0");
    m_mode = Mode::Damp;
    m_busHealthy = true;
    updateButtonState();
    emit connectedChanged();
    emit deviceInfoChanged();
    emit telemetryChanged();
}

void AppController::setFirmwarePath(const QString &path)
{
    m_firmwarePath = path;
    const QFileInfo info(path);
    m_firmwareFileName = info.fileName().isEmpty()
        ? QStringLiteral("No firmware selected")
        : info.fileName();
    emit firmwareChanged();
}

void AppController::startOrCancelFlash()
{
    if (m_flashing) {
        m_flashTimer.stop();
        m_flashing = false;
        m_flashProgress = 0.0;
        emit flashingChanged();
        emit flashProgressChanged();
        return;
    }

    if (!m_connected || m_firmwarePath.isEmpty())
        return;

    m_flashing = true;
    m_flashProgress = 0.0;
    emit flashingChanged();
    emit flashProgressChanged();
    m_flashTimer.start(120);
}

void AppController::enableArm()
{
    if (!m_enableEnabled)
        return;
    m_mode = Mode::Enable;
    updateButtonState();
}

void AppController::dragArm()
{
    if (!m_dragEnabled)
        return;
    m_mode = Mode::Drag;
    updateButtonState();
}

void AppController::disableArm()
{
    if (!m_disableEnabled)
        return;
    m_mode = Mode::Damp;
    updateButtonState();
}

void AppController::homeArm()
{
    if (!m_homeEnabled)
        return;
    // Keep current mode; home is a one-shot action in the original app.
}

void AppController::updateButtonState()
{
    if (!m_connected) {
        m_enableEnabled = false;
        m_dragEnabled = false;
        m_disableEnabled = false;
        m_homeEnabled = false;
        emit buttonStateChanged();
        return;
    }

    const bool isActive = (m_mode == Mode::Enable || m_mode == Mode::Drag);
    const bool isDamp = (m_mode == Mode::Damp);

    m_enableEnabled = isDamp || m_mode == Mode::Drag;
    m_dragEnabled = isDamp || m_mode == Mode::Enable;
    m_disableEnabled = isActive;
    m_homeEnabled = isActive;
    emit buttonStateChanged();
}

void AppController::tickTelemetry()
{
    if (!m_connected) {
        emit telemetryChanged();
        return;
    }

    ++m_uptimeSeconds;
    const quint32 s = m_uptimeSeconds / 10; // timer is 100ms
    m_uptime = QStringLiteral("%1:%2:%3")
                   .arg(s / 3600, 2, 10, QLatin1Char('0'))
                   .arg((s % 3600) / 60, 2, 10, QLatin1Char('0'))
                   .arg(s % 60, 2, 10, QLatin1Char('0'));

    const double t = m_uptimeSeconds * 0.1;
    QVariantList next;
    const QStringList names = {
        QStringLiteral("J1"), QStringLiteral("J2"), QStringLiteral("J3"),
        QStringLiteral("J4"), QStringLiteral("J5"), QStringLiteral("J6"),
        QStringLiteral("夹爪")
    };
    for (int i = 0; i < names.size(); ++i) {
        const double angle = 30.0 * std::sin(t * 0.4 + i * 0.7);
        const double torque = 2.0 * std::sin(t * 0.55 + i);
        const double temp = 35.0 + 8.0 * std::sin(t * 0.2 + i * 0.3) + i;
        next.append(makeJoint(names[i], angle, torque, temp));
    }
    m_joints = next;

    const double x = 0.35 + 0.02 * std::sin(t * 0.3);
    const double y = 0.10 + 0.01 * std::cos(t * 0.25);
    const double z = 0.42;
    const double roll = 5.0 * std::sin(t * 0.2);
    const double pitch = 3.0 * std::cos(t * 0.18);
    const double yaw = 12.0 * std::sin(t * 0.15);
    m_poseText = QStringLiteral("X: %1  Y: %2  Z: %3  R: %4°  P: %5°  Y: %6°")
                     .arg(x, 0, 'f', 3)
                     .arg(y, 0, 'f', 3)
                     .arg(z, 0, 'f', 3)
                     .arg(roll, 0, 'f', 2)
                     .arg(pitch, 0, 'f', 2)
                     .arg(yaw, 0, 'f', 2);

    m_busHealthy = true;
    emit telemetryChanged();
}

void AppController::resetDeviceInfo()
{
    m_boardName = QStringLiteral("---");
    m_firmwareVersion = QStringLiteral("---");
    m_protocolVersion = QStringLiteral("---");
    m_uptime = QStringLiteral("---");
    emit deviceInfoChanged();
}

QVariantMap AppController::makeJoint(const QString &name, double angle, double torque, double temp) const
{
    QVariantMap m;
    m.insert(QStringLiteral("name"), name);
    m.insert(QStringLiteral("angle"), angle);
    m.insert(QStringLiteral("torque"), torque);
    m.insert(QStringLiteral("temp"), temp);
    return m;
}
