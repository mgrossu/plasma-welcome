/*
 *  SPDX-FileCopyrightText: 2021 Felipe Kinoshita <kinofhek@gmail.com>
 *  SPDX-FileCopyrightText: 2022 Nate Graham <nate@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import org.kde.kirigami 2.15 as Kirigami

import org.kde.welcome 1.0

Kirigami.ApplicationWindow {
    id: root

    minimumWidth: Kirigami.Units.gridUnit * 40
    minimumHeight: Kirigami.Units.gridUnit * 35
    width: Kirigami.Units.gridUnit * 42
    height: Kirigami.Units.gridUnit * 37

    header: QQC2.ToolBar {
        contentItem: RowLayout {
            QQC2.Button {
                Layout.alignment: Qt.AlignLeft
                action: Kirigami.Action {
                    text: pageStack.currentIndex === 0 ? i18nc("@action:button", "Skip") : i18nc("@action:button", "Back")
                    icon.name: pageStack.currentIndex === 0 ? "dialog-cancel" : "arrow-left"
                    shortcut: "Left"
                    onTriggered: {
                        if (pageStack.layers.depth > 1) {
                            pageStack.layers.pop()
                        } else if (pageStack.currentIndex != 0) {
                            pageStack.currentIndex -= 1
                        } else {
                            Config.skip = true;
                            Config.save();
                            Controller.removeFromAutostart();
                            Qt.quit();
                        }
                    }
                }
            }
            QQC2.Button {
                visible: pageStack.layers.depth === 1
                Layout.alignment: Qt.AlignRight
                action: Kirigami.Action {
                    text: pageStack.currentIndex === pageStack.depth - 1 ? i18nc("@action:button", "Finish") : i18nc("@action:button", "Next")
                    icon.name: pageStack.currentIndex === pageStack.depth - 1 ? "dialog-ok-apply" : "arrow-right"
                    shortcut: "Right"
                    onTriggered: {
                        if (pageStack.currentIndex < pageStack.depth - 1) {
                            pageStack.currentIndex += 1
                        } else {
                            Config.done = true;
                            Config.save();
                            Controller.removeFromAutostart();
                            Qt.quit()
                        }
                    }
                }
            }
        }
    }

    pageStack.globalToolBar.style: Kirigami.ApplicationHeaderStyle.None
    pageStack.defaultColumnWidth: width
    pageStack.initialPage: [welcome, network, discover, systemsettings, kcm_kaccounts, kcm_feedback, contribute]
    Component.onCompleted: pageStack.currentIndex = 0 //TODO: push new pages onlly as needed

    Welcome {id: welcome}
    Network {id: network}
    Discover {id: discover}
    SystemSettings {id:systemsettings}
    Contribute {id: contribute}
    KCM {
        id: kcm_feedback
        Module {
            id: moduleFeedback
            path: "kcm_feedback"
        }
        kcm: moduleFeedback.kcm
        internalPage: moduleFeedback.kcm.mainUi
    }
    KCM {
        id: kcm_kaccounts

        heading: i18n("Online Accounts")
        description: i18n("Configure your internet services")

        Module {
            id: moduleAccounts
            path: "kcm_kaccounts"
        }
        kcm: moduleAccounts.kcm
        internalPage: moduleAccounts.kcm.mainUi
    }
}
