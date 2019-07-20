/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/


#ifndef HISTORY_HPP
#define HISTORY_HPP

#include <QObject>
#include <QString>
#include <QFile>
#include <QTextStream>

class History: public QObject {
    Q_OBJECT
private:
    QString m_history;
    QFile *m_historyFile = new QFile("history.file");

public:
    explicit History(QObject *parent = nullptr);
    ~History();

signals:

public slots:
    void loadHistory();
    void saveHistory();
    QString getHistory();
    void appenToHistory(QString practiceResult, QString dateAndTime);
    void clearHistory();
};

#endif // HISTORY_HPP
