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

// Qt includes

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

    // Add practice results at the end of practice history.
    void appenToHistory(QString practiceResult, QString dateAndTime);

    // Clear history file.
    void clearHistory();
};

#endif // HISTORY_HPP
