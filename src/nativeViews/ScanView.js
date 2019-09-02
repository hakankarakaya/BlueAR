import React, { Component } from "react";
import PropTypes from "prop-types";
import {
  requireNativeComponent,
  UIManager,
  findNodeHandle
} from "react-native";

const COMPONENT_NAME = "ScanView";
const RNScanView = requireNativeComponent(COMPONENT_NAME);

// Native scan view
export default class ScanView extends Component {
  static propTypes = {
    onSurfaceDetected: PropTypes.func
  };

  _onSurfaceDetected = event => {
    // call it only if a handler was passed as props
    if (this.props.onSurfaceDetected) {
      this.props.onSurfaceDetected(event.nativeEvent);
    }
  };

  render() {
    const { style } = this.props;
    return (
      <RNScanView
        style={style}
        onSurfaceDetected={this._onSurfaceDetected}
        ref={ref => (this.ref = ref)}
      />
    );
  }

  // Native communication functions 

  addHorizontalSurfaceModel = (...args) => {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.ref),
      UIManager[COMPONENT_NAME].Commands.addHorizontalSurfaceModel,
      [...args]
    );
  };
  addPlanetModel = (...args) => {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.ref),
      UIManager[COMPONENT_NAME].Commands.addPlanetModel,
      [...args]
    );
  };
  addWallpaperTexture = (...args) => {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.ref),
      UIManager[COMPONENT_NAME].Commands.addWallpaperTexture,
      [...args]
    );
  };
  addCharacterAnimation = (...args) => {
    UIManager.dispatchViewManagerCommand(
      findNodeHandle(this.ref),
      UIManager[COMPONENT_NAME].Commands.addCharacterAnimation,
      [...args]
    );
  };
}
