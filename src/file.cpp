/* Typing.io
*
* This file is part of the Typing.io.
*
* Authors:
* Qusai Hroub <qusaihroub.r@gmail.com>
*
*/

#include "file.hpp"

File::File(QObject *parent) : QObject(parent) {

}

File::File(QString name, QString extension, QString path, bool isFile, QObject *parent) : QObject(parent), m_type(isFile)  {
    initFile(name, extension, path);
}

File::~File () {
    delete m_file;
}

void File::loadAll() {
    if (!m_file->open(QIODevice::ReadOnly | QIODevice::Text)) {
        return;
    }

    m_contentOfFile = m_file->readAll();

    m_file->close();
}

void File::saveFile() {
    if (!m_file->open(QIODevice::WriteOnly | QIODevice::Text)) {
        return;
    }

    QTextStream WriteToFile(m_file);
    WriteToFile << m_contentOfFile;

    m_file->close();
}

QVariantList File::scanDir() {
    QVariant item;
    QVariantList list;
    QDir dir(m_pathOfFile);

    if (!dir.exists() || !dir.isReadable()) {
        return list;
    }

    QDirIterator iter(dir);
    while (iter.hasNext()) {
        QString next = iter.next();
        QString base = iter.fileName();
        if (base == "." || base == "..") {
            continue;
        }
        if (base.endsWith(".c") || base.endsWith(".cpp") || base.endsWith(".java")) {
            QString extetension;

            while (base.length()) {
                if (base[base.length() - 1] == '.') {
                    base.remove(base.length() - 1,1);
                    break;
                }
                extetension.insert(0, base[base.length() - 1]);
                base.remove(base.length() - 1,1);
            }

            File *file = new File(base, extetension, iter.path());
            item.setValue(file);
            list.append(item);
        }

        QDir qDir(next);

        if (!qDir.isEmpty()) {
            File *file = new File(base, "", iter.path(), false);
            item.setValue(file);
            list.append(item);
        }
    }

    return list;
}

void File::CreateFolder(QString path) {
    QDir dir(path);

    // Create folder if it not exists.
    if (!dir.exists()) {
        dir.mkdir(path);
    }
}

void File::removeFolder(QString path) {
    QDir dir(path);

    // Remove folder if it exists.
    if (dir.exists()) {
        dir.mkdir(path);
    }
}

void File::initFile(QString name, QString extension, QString path, bool isFile) {
    m_nameOfFile = name;
    m_extensionOfFile = extension;
    m_pathOfFile = path;
    m_type = isFile;

    if (m_file != nullptr) {
        delete m_file;
    }
    if (path != "" && (*(path.end() - 1) != '\\' || *(path.end() - 1) != '/')) {
        path += "\\";
    }

    m_file = new QFile(path + name + "." + extension);
}

void File::setContent(QString content) {
    m_contentOfFile = content;
}

void File::append(QString content) {
    m_contentOfFile += content;
}

QString File::getContent() {
    return m_contentOfFile;
}

QString File::getName() {
    return m_nameOfFile;
}

QString File::getPath() {
    return m_pathOfFile;
}

QString File::getFullPath() {
    QString path = m_pathOfFile;
    if (*(path.end() - 1) != '\\' || *(path.end() - 1) != '/') {
        path += '/';
    }
    path += m_nameOfFile;
    return path;
}

QString File::getExtension() {
    return m_extensionOfFile;
}

void File::clear() {
    m_contentOfFile.clear();
    saveFile();
}
