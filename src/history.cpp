/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/


#include "history.hpp"

History::History(QObject *parent) : QObject(parent) {

}

History::~History() {
    delete m_historyFile;
}

void History::loadHistory() {
    if (!m_historyFile->open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    m_history = m_historyFile->readAll();

    m_historyFile->close();
}

void History::saveHistory() {
    if (!m_historyFile->open(QIODevice::WriteOnly | QIODevice::Text))
           return;

    QTextStream WriteToFile(m_historyFile);
    WriteToFile << m_history;

    m_historyFile->close();
}

QString History::getHistory() {
    return m_history;
}

void History::appenToHistory(QString practiceResult, QString dateAndTime) {
    if (m_history.length() != 0) {
        m_history += "\n\n";
    }
    m_history += "Date And Time: " + dateAndTime + "\n\n" + practiceResult;
}

void History::clearHistory() {
    m_history = QString();
    saveHistory();
}
