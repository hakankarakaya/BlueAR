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

export default class HorizontalSurfaceModelGrid extends Component {

    render() {
        const { style } = this.props;
        return (
            <View style={styles.container}>
                <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                    this.setState({
                        slideAnimationDialog: true,
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
        alignItems: "flex-start",
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
