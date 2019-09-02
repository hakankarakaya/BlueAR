import React, { Component } from "react";
import {
    Image,
    StyleSheet,
    View,
    TouchableHighlight
} from "react-native";
import PropTypes from 'prop-types';

// Grid view showing wallpaper objets in popup
export default class WallpaperGrid extends Component {

    static propTypes = {
        items: PropTypes.array.isRequired,
        isHidden: PropTypes.bool,
        onWallpaperSelected: PropTypes.func
    };

    render() {
        const { style } = this.props;
        if (this.props.isHidden) {
            return (null);
        } else {
            return (
                <View style={styles.container}>
                    {this.props.items.map((item, index) => {
                        return (
                            <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                                this.props.onWallpaperSelected(item)
                                this.setState({
                                    slideAnimationDialog: true,
                                });
                            }}>
                                <View style={styles.outerCircle}>
                                    <View style={styles.innerCircle}>
                                        <Image source={{ uri: item.wallpaperSmallImageURL }} style={styles.thumbnailImage} />
                                    </View>
                                </View>
                            </TouchableHighlight>
                        )
                    })
                    }
                </View>
            );
        }
    }
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: "row"
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
        backgroundColor: 'rgba(255, 255, 255, 0.4)'
    },
    btnIcon: {
        height: 30,
        width: 30,
        color: '#0A8ED6',
        fontSize: 30
    },
    thumbnailImage: {
        height: 30,
        width: 30,
    },
    btnClickContain: {
        borderRadius: 32,
        width: 60,
        height: 60
    },
});
