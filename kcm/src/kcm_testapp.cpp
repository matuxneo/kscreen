/*
    Copyright (C) 2013  Dan Vratil <dvratil@redhat.com>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include <KAboutData>
#include <KLocalizedString>
#include <QApplication>

#include <kscreen/getconfigoperation.h>

// #include <QQuickDebuggingEnabler>

#include "widget.h"

int main(int argc, char **argv)
{
//     QQuickDebuggingEnabler enabler;
    QApplication app(argc, argv);

    KAboutData aboutData(QStringLiteral("kcm_testapp"), QStringLiteral("kcm_testapp"), i18n("KCM Test App"), QStringLiteral("1.0"), KAboutLicense::GPL);

    Widget widget;
    widget.resize(800, 600);
    widget.show();

    QObject::connect(new KScreen::GetConfigOperation(), &KScreen::GetConfigOperation::finished,
                     [&](KScreen::ConfigOperation *op) {
                        widget.setConfig(qobject_cast<KScreen::GetConfigOperation*>(op)->config());
                    });

    return app.exec();
}
