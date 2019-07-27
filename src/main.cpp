/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

// Qt includes

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>
#include <QQmlContext>

// Local includes

#include "typing.hpp"
#include "userprogress.hpp"
#include "history.hpp"

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

    QCommandLineParser commandLineParser;
    commandLineParser.addHelpOption();
    commandLineParser.addVersionOption();
    commandLineParser.setApplicationDescription("Typing.io");
    commandLineParser.process(app);

    /*!
     * \brief qmlRegisterType<Typing>
     * Register Typing as new qml Type.
     */
    qmlRegisterType<Typing>("typing.io", 0, 1, "Typing");

    /*!
     * \brief qmlRegisterType<UserProgress>
     * Register UserProgress as new qml Type.
     */
    qmlRegisterType<UserProgress>("typing.io.userprogress", 0, 1, "UserProgress");

    /*!
     * \brief qmlRegisterType<History>
     * Register History as new qml Type.
     */
    qmlRegisterType<History>("typing.io.history", 0, 1, "History");

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
