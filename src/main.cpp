/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>

#include "typing.hpp"

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    /*!
     * \brief QCoreApplication::setApplicationName
     * This property holds the name of this application.
     */
    QCoreApplication::setApplicationName("Typing.io");

    /*!
     * \brief engine
     * To provide a convenient way to load a single QML file.
     */
    QQmlApplicationEngine engine;

    QCommandLineParser p;
    p.addHelpOption();
    p.addVersionOption();
    p.setApplicationDescription("Typing.io");
    p.process(app);

    /*!
     * \brief qmlRegisterType<Typing>
     * Register Typing as new qml Type.
     */
    qmlRegisterType<Typing>("typing.io", 0, 1, "Typing");

    /*!
     * \brief url
     * Class provides a convenient interface for working with URLs.
     * Here use to make connection with mainWindow qml file.
     */
    const QUrl url(QStringLiteral("qrc:/qml/mainWindow.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
