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
import { Icon } from 'native-base';
import Dialog, {
    DialogTitle,
    DialogContent,
    DialogFooter,
    DialogButton,
    SlideAnimation,
    ScaleAnimation,
} from 'react-native-popup-dialog';

import HorizontalSurfaceModelGrid from "./HorizontalSurfaceModelGrid"

export default class OverlayMenuView extends Component {
    state = {
        defaultAnimationDialog: false,
        scaleAnimationDialog: false,
        slideAnimationDialog: false,
        dialogTitle: "",
        explanationText: "",
    };

    render() {
        const { style } = this.props;
        return (
            <View style={styles.container}>
                <View style={styles.btnContainer}>
                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            dialogTitle: "Horizontal Surface Objects",
                            slideAnimationDialog: true,
                            explanationText: "Some Horizontal Surface Objects"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    type="FontAwesome"
                                    name='cube'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            dialogTitle: "Planet Objects",
                            slideAnimationDialog: true,
                            explanationText: "Some Planet Objects"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    type="FontAwesome"
                                    name='globe'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            dialogTitle: "Change Wallpaper",
                            slideAnimationDialog: true,
                            explanationText: "Some Wallpapers"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    type="FontAwesome"
                                    name='paint-brush'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            dialogTitle: "Add Animation to Character",
                            slideAnimationDialog: true,
                            explanationText: "Some Character Animations"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    type="FontAwesome"
                                    name='male'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>
                </View>

                <Dialog
                    onDismiss={() => {
                        this.setState({ slideAnimationDialog: false });
                    }}
                    onTouchOutside={() => {
                        this.setState({ slideAnimationDialog: false });
                    }}
                    visible={this.state.slideAnimationDialog}
                    dialogTitle={<DialogTitle title={this.state.dialogTitle}/>}
                    dialogAnimation={new SlideAnimation({ slideFrom: 'bottom' })}
                    dialogStyle={{ position: 'absolute', bottom: 0, width:'100%' }}>

                    <DialogContent>
                        <Text style={{ margin: 10 }}>
                            {this.state.explanationText}
                        </Text>
                        <HorizontalSurfaceModelGrid>

                        </HorizontalSurfaceModelGrid>
                    </DialogContent>
                </Dialog>
            </View>
        );
    }

    objectSelected = (...args) => {
        UIManager.dispatchViewManagerCommand(
            findNodeHandle(this.ref),
            UIManager[COMPONENT_NAME].Commands.updateWallpaperTexture,
            [...args]
        );
    };
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        alignItems: "stretch",
    },
    outerCircle: {
        borderRadius: 25,
        width: 50,
        height: 50,
        backgroundColor: 'rgba(255, 255, 255, 0.8)',
        margin: 5,
    },
    innerCircle: {
        flex: 1,
        alignItems: "center",
        justifyContent: "center",
        borderRadius: 21,
        width: 42,
        height: 42,
        margin: 4,
        backgroundColor: 'rgba(255, 255, 255, 0.4)',
    },
    btnContainer: {
        flex: 1,
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'flex-end',
        alignSelf: 'stretch',
        margin: 10,
    },
    btnIcon: {
        height: 30,
        width: 30,
        color: '#0A8ED6',
        fontSize: 30
    },
    btnClickContain: {
        borderRadius: 32,
    },
});
