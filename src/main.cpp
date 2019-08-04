/* Trying.io
*
* This file is part of the Trying.io.
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
#include "file.hpp"

int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    /*!
     * \brief QCoreApplication::setApplicationName
     * This property holds the name of this application.
     */
    QCoreApplication::setApplicationName("Trying.io");

    /*!
     * \brief QCoreApplication::setApplicationVersion
     * This property holds the version of this application.
     */
    QCoreApplication::setApplicationVersion("0.2");

    /*!
     * \brief engine
     * To provide a convenient way to load a single QML file.
     */
    QQmlApplicationEngine engine;

    QCommandLineParser commandLineParser;
    commandLineParser.addHelpOption();
    commandLineParser.addVersionOption();
    commandLineParser.setApplicationDescription("Trying.io");
    commandLineParser.process(app);

    /*!
     * \brief qmlRegisterType<Typing>
     * Register Typing as new qml Type.
     */
    qmlRegisterType<Typing>("trying.io.typing", 0, 2, "Typing");

    /*!
     * \brief qmlRegisterType<UserProgress>
     * Register UserProgress as new qml Type.
     */
    qmlRegisterType<UserProgress>("trying.io.userprogress", 0, 2, "UserProgress");

    /*!
     * \brief qmlRegisterType<History>
     * Register History as new qml Type.
     */
    qmlRegisterType<History>("trying.io.history", 0, 2, "History");

    /*!
     * \brief qmlRegisterType<File>
     * Register TFile & TFolder as new qml Type.
     */
    qmlRegisterType<TFile>("trying.io.file", 0, 2, "TFile");
    qmlRegisterType<TFolder>("trying.io.folder", 0, 2, "TFolder");

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
