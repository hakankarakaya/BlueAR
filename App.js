/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 *
 * @format
 * @flow
 */

import React, { Component } from "react";
import {
  StyleSheet,
  View
} from "react-native";

import ScanView from "./src/nativeViews/ScanView";
import OverlayMenuView from "./src/containers/OverlayMenuView";

console.disableYellowBox = true;

export default class App extends Component {

  surfaceDetected = e => {
    this.setState({ surface: e.surface })
    this.overlayMenuRef.surfaceChanged(e.surface);
  };

  onHorizontalSurfaceModelSelected = item => {
    console.log("onHorizontalSurfaceModelSelected");
    this.objectRef.addHorizontalSurfaceModel(item.id, item.modelURL);
  };
  onPlanetModelSelected = item => {
    console.log("onPlanetModelSelected");
    this.objectRef.addPlanetModel(item.id, item.modelURL);
  };
  onWallpaperSelected = item => {
    console.log("onWallpaperSelected");
    this.objectRef.addWallpaperTexture(item.id, item.wallpaperURL);
  };
  onCharacterAnimationSelected = item => {
    console.log("onCharacterAnimationSelected");
    this.objectRef.addCharacterAnimation(item.id, item.animationURL);
  };

  render() {
    return (
      <View style={styles.container}>
        <ScanView
          style={styles.fullScreenContainer}
          onSurfaceDetected={this.surfaceDetected}
          ref={e => (this.objectRef = e)}
        />

        <OverlayMenuView
          style={styles.fullScreenContainer}
          onHorizontalSurfaceModelSelected={this.onHorizontalSurfaceModelSelected}
          onPlanetModelSelected={this.onPlanetModelSelected}
          onWallpaperSelected={this.onWallpaperSelected}
          onCharacterAnimationSelected={this.onCharacterAnimationSelected}
          ref={e => (this.overlayMenuRef = e)}
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
