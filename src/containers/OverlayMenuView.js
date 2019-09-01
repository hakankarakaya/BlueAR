import React, { Component } from "react";
import {
    StyleSheet,
    Text,
    View,
    TouchableHighlight
} from "react-native";
import { Icon } from 'native-base';
import Dialog, {
    DialogTitle,
    DialogContent,
    SlideAnimation,
} from 'react-native-popup-dialog';
import PropTypes from "prop-types";

//Import grid views in popup
import HorizontalSurfaceModelGrid from "../components/HorizontalSurfaceModelGrid";
import PlanetModelGrid from "../components/PlanetModelGrid";
import WallpaperGrid from "../components/WallpaperGrid";
import CharacterAnimationGrid from "../components/CharacterAnimationGrid";

//Firebase configuration and initialize
import Firebase from 'firebase';
let config = {
    apiKey: "AIzaSyAhkrXGFzo8Jc2zNjnNm2r-c7iB7EbQ4xs",
    authDomain: "bluear-3c8c6.firebaseapp.com",
    databaseURL: "https://bluear-3c8c6.firebaseio.com",
    projectId: "bluear-3c8c6",
    storageBucket: "",
    messagingSenderId: "852849088125",
    appId: "1:852849088125:web:462222f46f790a41"
};
let app = Firebase.initializeApp(config);
export const db = app.database();

//Firebase db object reference variables
let wallpapersRef = db.ref('/Wallpapers');
let planetModelsRef = db.ref('/PlanetModels');
let horizontalSurfaceModelsRef = db.ref('/HorizontalSurfaceModels');
let characterAnimationsRef = db.ref('/CharacterAnimations');

export default class OverlayMenuView extends Component {
    state = {
        //Dialog show hide state
        slideAnimationDialog: false,
        
        //Grid view in popup show hide state
        horizontalSurfaceModelGridIsHidden: true,
        wallpaperGridIsHidden: true,
        planetGridIsHidden: true,
        characterAnimationGridIsHidden: true,

        //Dialog properties
        dialogTitle: "",
        explanationText: "",

        //Selected grid view objects from firebase db
        selectedItems: [],

        //Firebase db object array
        wallpapers: [],
        planetModels: [],
        horizontalSurfaceModels: [],
        characterAnimations: []
    };

    static propTypes = {
        onHorizontalSurfaceModelSelected: PropTypes.func,
        onPlanetModelSelected: PropTypes.func,
        onWallpaperSelected: PropTypes.func,
        onCharacterAnimationSelected: PropTypes.func
    };

    //Send selected model data to native
    _onHorizontalSurfaceModelSelected = item => {
        this.props.onHorizontalSurfaceModelSelected(item);
    };
    _onPlanetModelSelected = item => {
        this.props.onPlanetModelSelected(item);
    };
    _onWallpaperSelected = item => {
        this.props.onWallpaperSelected(item);
    };
    _onCharacterAnimationSelected = item => {
        this.props.onCharacterAnimationSelected(item);
    };

    //Get Firebase db objects
    componentWillMount() {
        wallpapersRef.on('value', (snapshot) => {
            let data = snapshot.val();
            let wallpapers = Object.values(data);
            this.setState({ wallpapers });
            console.log("Wallpapers ok!");
        });
        planetModelsRef.on('value', (snapshot) => {
            let data = snapshot.val();
            let planetModels = Object.values(data);
            this.setState({ planetModels });
            console.log("PlanetModels ok!");
        });
        horizontalSurfaceModelsRef.on('value', (snapshot) => {
            let data = snapshot.val();
            let horizontalSurfaceModels = Object.values(data);
            this.setState({ horizontalSurfaceModels });
            console.log("HorizontalSurfaceModels ok!");
        });
        characterAnimationsRef.on('value', (snapshot) => {
            let data = snapshot.val();
            let characterAnimations = Object.values(data);
            this.setState({ characterAnimations });
            console.log("CharacterAnimations ok!");
        });
    }

    render() {
        const { style } = this.props;
        return (
            <View style={styles.container}>
                <View style={styles.btnContainer}>
                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            horizontalSurfaceModelGridIsHidden: false,
                            dialogTitle: "Horizontal Surface Objects",
                            slideAnimationDialog: true,
                            explanationText: "Some Horizontal Surface Objects"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    ref={e => (this.horizontalSurfaceModelIcon = e)}
                                    type="FontAwesome"
                                    name='cube'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            planetGridIsHidden: false,
                            dialogTitle: "Planet Objects",
                            slideAnimationDialog: true,
                            explanationText: "Some Planet Objects"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    ref={e => (this.planetModelIcon = e)}
                                    type="FontAwesome"
                                    name='globe'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            wallpaperGridIsHidden: false,
                            dialogTitle: "Change Wallpaper",
                            slideAnimationDialog: true,
                            explanationText: "Some Wallpapers"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon
                                    ref={e => (this.wallpaperIcon = e)}
                                    type="FontAwesome"
                                    name='paint-brush'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>

                    <TouchableHighlight style={styles.btnClickContain} onPress={() => {
                        this.setState({
                            characterAnimationGridIsHidden: false,
                            dialogTitle: "Add Animation to Character",
                            slideAnimationDialog: true,
                            explanationText: "Some Character Animations"
                        });
                    }}>
                        <View style={styles.outerCircle}>
                            <View style={styles.innerCircle}>
                                <Icon 
                                    ref={e => (this.characterAnimationIcon = e)}
                                    type="FontAwesome"
                                    name='male'
                                    style={styles.btnIcon} />
                            </View>
                        </View>
                    </TouchableHighlight>
                </View>

                <Dialog
                    onDismiss={() => {
                        this.setState({
                            slideAnimationDialog: false,
                            horizontalSurfaceModelGridIsHidden: true,
                            planetGridIsHidden: true,
                            wallpaperGridIsHidden: true,
                            characterAnimationGridIsHidden: true
                        });
                    }}
                    onTouchOutside={() => {
                        this.setState({
                            slideAnimationDialog: false,
                            horizontalSurfaceModelGridIsHidden: true,
                            planetGridIsHidden: true,
                            wallpaperGridIsHidden: true,
                            characterAnimationGridIsHidden: true
                        });
                    }}
                    visible={this.state.slideAnimationDialog}
                    dialogTitle={<DialogTitle title={this.state.dialogTitle} />}
                    dialogAnimation={new SlideAnimation({ slideFrom: 'bottom' })}
                    dialogStyle={{ position: 'absolute', bottom: 0, width: '100%' }}>

                    <DialogContent>
                        <Text style={{ margin: 10 }}>
                            {this.state.explanationText}
                        </Text>
                        <HorizontalSurfaceModelGrid
                            onHorizontalSurfaceModelSelected={this._onHorizontalSurfaceModelSelected}
                            isHidden={this.state.horizontalSurfaceModelGridIsHidden}
                            items={
                                this.state.horizontalSurfaceModels
                            } />
                        <PlanetModelGrid
                            onPlanetModelSelected={this._onPlanetModelSelected}
                            isHidden={this.state.planetGridIsHidden}
                            items={
                                this.state.planetModels
                            } />
                        <WallpaperGrid
                            onWallpaperSelected={this._onWallpaperSelected}
                            isHidden={this.state.wallpaperGridIsHidden}
                            items={
                                this.state.wallpapers
                            } />
                        <CharacterAnimationGrid
                            onCharacterAnimationSelected={this._onCharacterAnimationSelected}
                            isHidden={this.state.characterAnimationGridIsHidden}
                            items={
                                this.state.characterAnimations
                            } />
                    </DialogContent>
                </Dialog>
            </View>
        );
    }

    /*
        When the native sends the surface information, 
        the part of the recommended models is painted in green.
    */
    surfaceChanged = (...args) => {
        this.horizontalSurfaceModelIcon.setNativeProps({ style:{color: '#0A8ED6'} });
        this.planetModelIcon.setNativeProps({ style:{color: '#0A8ED6'} });
        this.wallpaperIcon.setNativeProps({ style:{color: '#0A8ED6'} });
        this.characterAnimationIcon.setNativeProps({ style:{color: '#0A8ED6'} });

        console.log(args[0]);
        switch (args[0]) {
            case "Horizontal":
                this.horizontalSurfaceModelIcon.setNativeProps({ style:{color: '#3fba29'} });
                break;
            case "Vertical":
                this.wallpaperIcon.setNativeProps({ style:{color: '#3fba29'} });
                break;
            case "Hand":
                this.planetModelIcon.setNativeProps({ style:{color: '#3fba29'} });
                break;
            default:
                break;
        }
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
