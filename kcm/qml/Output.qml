/*
    Copyright (C) 2012  Dan Vratil <dvratil@redhat.com>

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

import QtQuick 1.1
import org.kde.kscreen 1.0

QMLOutput {

    id: root;

    signal clicked(string self);
    signal primaryTriggered(string self);
    signal enabledToggled(string self);
    signal mousePressed();
    signal mouseReleased();

    property bool isDragged: monitorMouseArea.drag.active;
    property bool isDragEnabled: true;
    property bool isToggleButtonVisible: false;
    property bool hasMoved: false;

    width: monitorMouseArea.width;
    height: monitorMouseArea.height;

    visible: (opacity > 0);
    opacity: output.connected ? 1.0 : 0.0;

    SystemPalette {

        id: palette;
    }

    MouseArea {

        id: monitorMouseArea;

        width: root.currentOutputWidth * screen.outputScale;
        height: root.currentOutputHeight * screen.outputScale

        anchors.centerIn: parent;

        opacity: root.output.enabled ? 1.0 : 0.5;
        transformOrigin: Item.Center;
        rotation: {
            if (output.rotation == KScreenOutput.None) {
                return 0
            } else if (output.rotation == KScreenOutput.Left) {
                return 270
            } else if (output.rotation == KScreenOutput.Inverted) {
                return 180;
            } else {
                return 90;
            }
        }

        hoverEnabled: true;
        preventStealing: true;

        drag {
            target: root;
            axis: Drag.XandYAxis;
            minimumX: 0;
            maximumX: screen.maxScreenSize.width - root.width;
            minimumY: 0;
            maximumY: screen.maxScreenSize.height - root.height;
            filterChildren: false;
        }

        drag.onActiveChanged: {
            /* If the drag is shorter then the animation then make sure
             * we won't end up in an inconsistent state */
            if (dragActiveChangedAnimation.running) {
                dragActiveChangedAnimation.complete();
            }

            dragActiveChangedAnimation.running = true;
        }

        onClicked: root.clicked(root.output.name);

        /* FIXME: This could be in 'Behavior', but MouseArea had
         * some complaints...to tired to investigate */
        PropertyAnimation {
            id: dragActiveChangedAnimation;

            target: monitor;
            property: "opacity";
            from: monitorMouseArea.drag.active ? 0.7 : 1.0
            to: monitorMouseArea.drag.active ? 1.0 : 0.7
            duration: 100;
            easing.type: "OutCubic";
        }

        Behavior on opacity {
            PropertyAnimation {
                property: "opacity";
                easing.type: "OutCubic";
                duration: 250;
            }
        }

        Behavior on rotation {
            RotationAnimation {
                easing.type: "OutCubic"
                duration: 250;
                direction: RotationAnimation.Counterclockwise;
            }
        }

        Behavior on width {
            PropertyAnimation {
                property: "width";
                easing.type: "OutCubic";
                duration: 150;
            }
        }

        Behavior on height {
            PropertyAnimation {
                property: "height";
                easing.type: "OutCubic";
                duration: 150;
            }
        }

        Rectangle {

            id: monitor;

            anchors.fill: parent;

            radius: 4;
            color: palette.window;
            smooth: true;

            border {
                color: palette.shadow;
                width: 1;
            }

            Rectangle {

                id: posLabel;

                anchors {
                    left: parent.left;
                    top: parent.top;
                }

                width: childrenRect.width + 5;
                height: childrenRect.height + 2;

                radius: 4;

                opacity: root.output.enabled && monitorMouseArea.drag.active ? 1.0 : 0.0;
                visible: opacity != 0.0;

                color: "#101010";

                Text {
                    id: posLabelText;

                    text: root.outputX + "," + root.outputY;

                    color: "white";

                    y: 2;
                    x: 2;
                }
            }

            Text {
                text: root.output.name;
            }

            Rectangle {

                id: orientationPanel;

                anchors {
                    left: parent.left;
                    right: parent.right;
                    bottom: parent.bottom;
                }

                height: 10;
                color: palette.shadow;
                smooth: true;
            }
        }
    }

    Behavior on opacity {
        PropertyAnimation {
            duration: 200;
            easing.type: "OutCubic";
        }
    }
}
