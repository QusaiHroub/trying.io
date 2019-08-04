/* Trying.io
*
* This file is part of the Trying.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "file.hpp"
File::File() {

}

File::File(QString name, QString path, QObject *parent) : QObject(parent) {
    initFile(name, path);
}

File::~File() {

}

void File::initFile(QString name, QString path) {
    m_nameOfFile = name;
    m_pathOfFile = path;

    if (path != "" && (*(path.end() - 1) != '\\' || *(path.end() - 1) != '/')) {
        path += "/";
    }
}

TFile::TFile() {

}

TFile::TFile(QString name, QString extension, QString path, QObject *parent) :  File(name, path, parent){
    initFile(extension);
}

void TFile::initFile(QString extension) {
    m_extensionOfFile = extension;

    if (m_file != nullptr) {
        delete m_file;
    }

    m_file = new QFile(TFile::getFullPath());
}

TFile::~TFile() {
    delete m_file;
}

QString File::getName() {
    return m_nameOfFile;
}

QString File::getPath() {
    return m_pathOfFile;
}

QString File::getFullPath() {
    QString path = getPath();
    if (*(path.end() - 1) != '\\' || *(path.end() - 1) != '/') {
        path += '/';
    }
    path += getName();

    return path;
}

void TFile::loadAll() {
    if (!m_file->open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }
    m_contentOfFile = m_file->readAll();

    m_file->close();
}

void TFile::saveFile() {
    if (!m_file->open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }

    QTextStream WriteToFile(m_file);
    WriteToFile << m_contentOfFile;

    m_file->close();
}

QString TFile::getFullPath() {
    return File::getFullPath() + '.' + m_extensionOfFile;
}

QString TFile::getContent() {
    return m_contentOfFile;
}

QString TFile::getExtension() {
    return m_extensionOfFile;
}

void TFile::setContent(QString content) {
    m_contentOfFile = content;
}

void TFile::append(QString content) {
    m_contentOfFile += content;
}

void TFile::clear() {
    m_contentOfFile.clear();
    saveFile();
}

TFolder::TFolder() {

}

TFolder::TFolder(QString name, QString path, QObject *parent) : File(name, path, parent) {

}

QVariantList TFolder::scanForFiles() {
    QVariant item;
    QVariantList list;
    QDir dir(getFullPath());
    dir.setFilter(QDir::Files);
    dir.setNameFilters(m_extensionList);

    if (!dir.exists() || !dir.isReadable()) {
        return list;
    }

    QDirIterator iter(dir);

    while (iter.hasNext()) {
        QString next = iter.next();
        QString base = iter.fileName();
        QString path = iter.path();
        QString extetension;

        if (base == "." || base == "..") {
            continue;
        }

        while (base.length()) {
            if (base[base.length() - 1] == '.') {
                base.remove(base.length() - 1,1);
                break;
            }
            extetension.insert(0, base[base.length() - 1]);
            base.remove(base.length() - 1,1);
        }

        File *file = new TFile(base, extetension, path);
        item.setValue(file);
        list.append(item);
    }

    return list;
}

QVariantList TFolder::scanForDirectories() {
    QVariant item;
    QVariantList list;
    QDir dir(getFullPath());
    dir.setFilter(QDir::Dirs);

    if (!dir.exists() || !dir.isReadable()) {
        return list;
    }

    QDirIterator iter(dir);

    while (iter.hasNext()) {
        QString next = iter.next();
        QString base = iter.fileName();
        QString path = iter.path();

        if (base == "." || base == "..") {
            continue;
        }

        File *folder = new TFolder(base, path);
        item.setValue(folder);
        list.append(item);
    }

    return list;
}

void TFolder::createFolder(QString path) {
    QDir dir(path);

    // Create folder if it not exists.
    if (!dir.exists()) {
        dir.mkdir(path);
    }
}

void TFolder::removeFolder(QString path) {
    QDir dir(path);

    // Remove folder if it exists.
    if (dir.exists()) {
        dir.mkdir(path);
    }
}

void TFolder::create() {
    createFolder(getFullPath());
}

void TFolder::remove() {
    removeFolder(getFullPath());
}


