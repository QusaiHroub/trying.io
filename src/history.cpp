/* Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "history.hpp"

History::History(QObject *parent) : QObject(parent) {

}

History::~History() {
    delete m_history;
}

void History::loadHistory() {
    m_history->loadAll();
}

void History::saveHistory() {
    m_history->saveFile();
}

QString History::getHistoryContent() {
    return m_history->getContent();
}

void History::append(QString practiceResult, QString dateAndTime) {
    QString content;
    if (m_history->getContent().length() != 0) {
        content += "\n\n";
    }
    content += "Date And Time: " + dateAndTime + "\n\n" + practiceResult;
    m_history->append(content);
}

void History::clearHistory() {
    m_history->clear();
}
