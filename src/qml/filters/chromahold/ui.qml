/*
 * Copyright (c) 2019 Meltytech, LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import Shotcut.Controls 1.0
import QtQuick.Controls.Styles 1.1

Item {
    property string colorParam: 'av.color'
    property string colorDefault: '0x000000'
    property string distanceParam: 'av.similarity'
    property double distanceDefault: 10
    property var defaultParameters: [colorParam, distanceParam]
    width: 350
    height: 50
    Component.onCompleted: {
        presetItem.parameters = defaultParameters
        if (filter.isNew) {
            // Set default parameter values
            filter.set(colorParam, colorDefault)
            filter.set(distanceParam, distanceDefault / 100)
            filter.savePreset(defaultParameters)
        }
        colorPicker.value = filter.get(colorParam)
        distanceSlider.value = filter.getDouble(distanceParam) * 100
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        Label {
            text: qsTr('Preset')
            Layout.alignment: Qt.AlignRight
        }
        Preset {
            id: presetItem
            Layout.columnSpan: 2
            onPresetSelected: {
                colorPicker.value = filter.get(colorParam)
                distanceSlider.value = filter.getDouble(distanceParam) * 100
            }
        }

        // Row 1
        Label {
            text: qsTr('Color')
            Layout.alignment: Qt.AlignRight
        }
        ColorPicker {
            id: colorPicker
            onValueChanged: {
                filter.set(colorParam, value)
                filter.set('disable', 0)
            }
            onPickStarted: filter.set('disable', 1)
            onPickCancelled: filter.set('disable', 0)
        }
        UndoButton {
            onClicked: colorPicker.value = colorDefault
        }

        // Row 2
        Label {
            text: qsTr('Distance')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: distanceSlider
            minimumValue: 0
            maximumValue: 100
            decimals: 1
            suffix: ' %'
            value: filter.getDouble(distanceParam) * 100
            onValueChanged: filter.set(distanceParam, value / 100)
        }
        UndoButton {
            onClicked: distanceSlider.value = distanceDefault
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
