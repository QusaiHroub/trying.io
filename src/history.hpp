/* Trying.io
*
* This file is part of the Trying.io.
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

// Local includes

#include "file.hpp"

class History: public QObject {
    Q_OBJECT
private:
    TFile *m_history = new TFile("history", "file", QDir::currentPath());

public:
    explicit History(QObject *parent = nullptr);
    ~History();

signals:

public slots:
    void loadHistory();
    void saveHistory();

    QString getHistoryContent();

    // Add practice results at the end of practice history.
    void append(QString practiceResult, QString dateAndTime);

    // Clear history file.
    void clearHistory();
};

#endif // HISTORY_HPP
