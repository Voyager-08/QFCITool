#pragma once

#include <QObject>
#include <QString>
#include <QStringList>
#include <QTimer>
#include <QVariantList>
#include <QVariantMap>

class AppController : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
    Q_PROPERTY(QString connectedPort READ connectedPort NOTIFY connectedChanged)
    Q_PROPERTY(QString connectionStatus READ connectionStatus NOTIFY connectedChanged)
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY portsChanged)
    Q_PROPERTY(QString firmwareFileName READ firmwareFileName NOTIFY firmwareChanged)
    Q_PROPERTY(double flashProgress READ flashProgress NOTIFY flashProgressChanged)
    Q_PROPERTY(bool flashing READ flashing NOTIFY flashingChanged)

    Q_PROPERTY(QString boardName READ boardName NOTIFY deviceInfoChanged)
    Q_PROPERTY(QString firmwareVersion READ firmwareVersion NOTIFY deviceInfoChanged)
    Q_PROPERTY(QString protocolVersion READ protocolVersion NOTIFY deviceInfoChanged)
    Q_PROPERTY(QString uptime READ uptime NOTIFY telemetryChanged)

    Q_PROPERTY(QString poseText READ poseText NOTIFY telemetryChanged)
    Q_PROPERTY(bool busHealthy READ busHealthy NOTIFY telemetryChanged)
    Q_PROPERTY(QString busStatusText READ busStatusText NOTIFY telemetryChanged)

    Q_PROPERTY(bool enableEnabled READ enableEnabled NOTIFY buttonStateChanged)
    Q_PROPERTY(bool dragEnabled READ dragEnabled NOTIFY buttonStateChanged)
    Q_PROPERTY(bool disableEnabled READ disableEnabled NOTIFY buttonStateChanged)
    Q_PROPERTY(bool homeEnabled READ homeEnabled NOTIFY buttonStateChanged)

    Q_PROPERTY(QVariantList joints READ joints NOTIFY telemetryChanged)

public:
    explicit AppController(QObject *parent = nullptr);

    bool connected() const { return m_connected; }
    QString connectedPort() const { return m_connectedPort; }
    QString connectionStatus() const;
    QStringList availablePorts() const { return m_ports; }
    QString firmwareFileName() const { return m_firmwareFileName; }
    double flashProgress() const { return m_flashProgress; }
    bool flashing() const { return m_flashing; }

    QString boardName() const { return m_boardName; }
    QString firmwareVersion() const { return m_firmwareVersion; }
    QString protocolVersion() const { return m_protocolVersion; }
    QString uptime() const { return m_uptime; }

    QString poseText() const { return m_poseText; }
    bool busHealthy() const { return m_busHealthy; }
    QString busStatusText() const;

    bool enableEnabled() const { return m_enableEnabled; }
    bool dragEnabled() const { return m_dragEnabled; }
    bool disableEnabled() const { return m_disableEnabled; }
    bool homeEnabled() const { return m_homeEnabled; }

    QVariantList joints() const { return m_joints; }

    Q_INVOKABLE void refreshPorts();
    Q_INVOKABLE void toggleConnection(const QString &portName);
    Q_INVOKABLE void setFirmwarePath(const QString &path);
    Q_INVOKABLE void startOrCancelFlash();
    Q_INVOKABLE void enableArm();
    Q_INVOKABLE void dragArm();
    Q_INVOKABLE void disableArm();
    Q_INVOKABLE void homeArm();

signals:
    void connectedChanged();
    void portsChanged();
    void firmwareChanged();
    void flashProgressChanged();
    void flashingChanged();
    void deviceInfoChanged();
    void telemetryChanged();
    void buttonStateChanged();

private:
    enum class Mode { Damp = 2, Enable = 0, Drag = 1 };

    void updateButtonState();
    void tickTelemetry();
    void resetDeviceInfo();
    QVariantMap makeJoint(const QString &name, double angle, double torque, double temp) const;

    bool m_connected = false;
    QString m_connectedPort;
    QStringList m_ports;
    QString m_firmwareFileName = QStringLiteral("No firmware selected");
    QString m_firmwarePath;
    double m_flashProgress = 0.0;
    bool m_flashing = false;

    QString m_boardName = QStringLiteral("---");
    QString m_firmwareVersion = QStringLiteral("---");
    QString m_protocolVersion = QStringLiteral("---");
    QString m_uptime = QStringLiteral("---");
    QString m_poseText;
    bool m_busHealthy = false;

    bool m_enableEnabled = false;
    bool m_dragEnabled = false;
    bool m_disableEnabled = false;
    bool m_homeEnabled = false;

    Mode m_mode = Mode::Damp;
    quint32 m_uptimeSeconds = 0;
    QVariantList m_joints;
    QTimer m_timer;
    QTimer m_flashTimer;
};
