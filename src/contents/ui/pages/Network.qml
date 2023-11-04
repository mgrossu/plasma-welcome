/*
 *  SPDX-FileCopyrightText: 2022 Nate Graham <nate@kde.org>
 *
 *  SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami
import org.kde.kirigamiaddons.components as KirigamiAddons

import org.kde.plasma.welcome
import org.kde.plasma.components as PC3
import org.kde.ksvg as KSvg
//NOTE: necessary for KSvg to load the Plasma theme
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasma5support as P5Support

GenericPage {
    id: root

    heading: i18nc("@info:window", "Access the Internet")
    description: xi18nc("@info:usagetip", "You can connect to the internet and manage your network connections with the <interface>Networks applet</interface>. To access it, click on the <interface>Networks</interface> icon in your <interface>System Tray</interface>, which lives in the bottom-right corner of the screen.")

    // To get the current date and time
    P5Support.DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }

    Loader {
        id: nmLoader
        source: "NetworkPlasmaNM.qml"

        // Defaults for when PlasmaNM is not available
        property bool statusIsConnected: false
        property bool iconIsConnecting: false
        property string iconConnectionIcon: "network-wireless-available"
        onLoaded: {
            statusIsConnected = Qt.binding(() => nmLoader.item.statusNetworkStatus == "Connected")
            iconIsConnecting = Qt.binding(() => nmLoader.item.iconConnecting)
            iconConnectionIcon = Qt.binding(() => nmLoader.item.iconConnectionIcon)
        }

        // Continue to the next page automatically when connected
        onStatusIsConnectedChanged: {
            if (statusIsConnected == true && pageStack.currentItem == root) {
                pageStack.currentIndex += 1
            }
        }
    }

    Kirigami.ShadowedRectangle {
        anchors.centerIn: parent
        width: Kirigami.Units.gridUnit * 20
        height: Kirigami.Units.gridUnit * 10
        radius: Kirigami.Units.smallSpacing
        Kirigami.Theme.inherit: false
        Kirigami.Theme.colorSet: Kirigami.Theme.View
        color: Kirigami.Theme.backgroundColor
        shadow.xOffset: 0
        shadow.yOffset: 2
        shadow.size: 10
        shadow.color: Qt.rgba(0, 0, 0, 0.3)

        // Container for everything else so we don't have the apply margins
        // multiple times
        Item {
            anchors.fill: parent
            anchors.margins: Kirigami.Units.smallSpacing

            // Wallpaper background image
            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: "file:" + Controller.installPrefix() + "/share/wallpapers/Next/contents/images/1024x768.png"
                // anchor the image to the bottom-right corner of the "screen"
                sourceClipRect: Qt.rect(1024-parent.width,
                                        768-parent.height,
                                        parent.width,
                                        parent.height)
            }

            // Wallpaper background image blur source behind panel
            Image {
                anchors.fill: panelContainer
                fillMode: Image.PreserveAspectCrop
                source: "file:" + Controller.installPrefix() + "/share/wallpapers/Next/contents/images/1024x768.png"
                sourceClipRect: Qt.rect(1024-panelContainer.width,
                                        768-panelContainer.height,
                                        panelContainer.width,
                                        panelContainer.height)

                layer.enabled: true
                layer.effect: GaussianBlur {
                    radius: 32
                    samples: 16
                    cached: true
                }
            }

            // Panel item container, so opacity won't propagate down
            Item {
                id: panelContainer

                readonly property int margins: Kirigami.Units.smallSpacing
                width: parent.width
                height: 36 // default panel height
                anchors.right: parent.right
                anchors.bottom: parent.bottom

                // Panel background
                KSvg.FrameSvgItem {
                    anchors.fill: parent
                    imagePath: "solid/widgets/panel-background"
                    enabledBorders: "TopBorder"
                    opacity: 0.75
                }

                // Fake System Tray items go in here
                RowLayout {
                    id: appletContainer

                    readonly property int iconSize: Kirigami.Units.iconSizes.roundedIconSize(height - (panelContainer.margins * 2))

                    anchors {
                        right: parent.right
                        rightMargin: Kirigami.Units.smallSpacing
                        top: parent.top
                        bottom: parent.bottom
                    }
                    spacing: Kirigami.Units.smallSpacing * 2

                    Item {
                        Layout.fillWidth: true
                    }

                    KSvg.SvgItem {
                        implicitWidth: appletContainer.iconSize
                        implicitHeight: appletContainer.iconSize
                        imagePath: "icons/klipper"
                        elementId: "klipper"
                    }
                    KSvg.SvgItem {
                        implicitWidth: appletContainer.iconSize
                        implicitHeight: appletContainer.iconSize
                        imagePath: "icons/audio"
                        elementId: "audio-volume-high"
                    }
                    KSvg.SvgItem {
                        implicitWidth: appletContainer.iconSize
                        implicitHeight: appletContainer.iconSize
                        imagePath: "icons/network"
                        elementId: nmLoader.iconConnectionIcon
                        PC3.BusyIndicator {
                            id: connectingIndicator

                            anchors.centerIn: parent
                            height: Math.min(parent.width, parent.height)
                            width: height
                            running: nmLoader.iconIsConnecting
                            visible: running
                        }
                    }
                    KSvg.SvgItem {
                        implicitWidth: appletContainer.iconSize
                        implicitHeight: appletContainer.iconSize
                        imagePath: "widgets/arrows"
                        elementId: "up-arrow"
                    }
                    ColumnLayout {
                        spacing: 0
                        PC3.Label {
                            color: PlasmaCore.Theme.textColor
                            text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
                            fontSizeMode: Text.Fit
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                            Layout.topMargin: Kirigami.Units.smallSpacing
                        }
                        PC3.Label {
                            color: PlasmaCore.Theme.textColor
                            text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleShortDate)
                            fontSizeMode: Text.Fit
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                            Layout.bottomMargin: Kirigami.Units.smallSpacing
                        }
                    }
                    KSvg.SvgItem {
                        implicitWidth: appletContainer.iconSize
                        implicitHeight: appletContainer.iconSize
                        imagePath: "icons/user"
                        elementId: "user-desktop"
                    }
                }
            }

            // Arrow container
            Kirigami.Icon {
                id: indicatorArrow
                readonly property int originalY: parent.height - panelContainer.height - height
                readonly property int translatedY: originalY - Kirigami.Units.gridUnit
                width : Kirigami.Units.iconSizes.large
                height: Kirigami.Units.iconSizes.large
                y: parent.height - panelContainer.height - height
                anchors {
                    right: panelContainer.right
                    rightMargin: appletContainer.width + appletContainer.anchors.rightMargin   // Align with the left of the appletContainer
                                  - ((appletContainer.iconSize + appletContainer.spacing) * 3) // Align with the right of the third icon
                                  + (appletContainer.iconSize / 2)                             // Align with the center of the icon
                                  - (width / 2)                                                // Center the arrow on the icon
                }
                source: "arrow-down"

                layer.enabled: true
                layer.effect: Glow {
                    radius: 6
                    samples: 17
                    spread: 0.5
                    color: "white"
                }

                SequentialAnimation on y {
                    running: pageStack.currentItem == root && !nmLoader.statusIsConnected
                    loops:  Animation.Infinite
                    alwaysRunToEnd: true
                    NumberAnimation {
                        from: indicatorArrow.originalY
                        to: indicatorArrow.translatedY
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        from: indicatorArrow.translatedY
                        to: indicatorArrow.originalY
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }
    }

    footer: KirigamiAddons.Banner {
        visible: Controller.patchVersion === 80
        text: i18nc("@info", "This page is being shown regardless of network connectivity because you are using a development version.")
    }
}
