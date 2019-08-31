/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from "react";
import {
  Platform,
  StyleSheet,
  Text,
  Button,
  View,
  TouchableOpacity,
  TouchableHighlight
} from "react-native";

import FirstClass from "./FirstClass"
import ScanView from "./ScanView";
import OverlayMenuView from "./OverlayMenuView";

FirstClass.addListener("onIncrement", res => {
  console.log("event onIncrement", res)
})
FirstClass.increment()
FirstClass.decrement()
FirstClass.decrement()

export default class App extends Component {

  surfaceDetected = e => {
    this.setState({ surface: e.surface })
    console.log("surface: " + e.surface);
  };

  updateNative = () => {
    this.objectRef.objectSelected("Wallpaper3");
  };

  render() {
    return (
      <View style={styles.container}>
        {/* <TouchableOpacity
          style={[styles.wrapper, styles.border]}
          onPress={this.updateNative}
          onLongPress={this.updateNative}
        >
        </TouchableOpacity> */}

        <ScanView
          style={styles.fullScreenContainer}
          onSurfaceDetected={this.surfaceDetected}
          ref={e => (this.objectRef = e)}
        />

        <OverlayMenuView
          style={styles.fullScreenContainer}
        />
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: "stretch"
  },
  fullScreenContainer: {
    flex: 1,
    position: "absolute",
    left: 0,
    top: 0,
    right: 0,
    bottom: 0
  },
  wrapper: {
    flex: 1,
    alignItems: "center",
    justifyContent: "center"
  },
  popupDialogStyle: {
    backgroundColor: 'lightgray',
    marginTop: 100,
  },
  border: {
    borderColor: "#eee",
    borderBottomWidth: 1
  },
});
