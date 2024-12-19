import {Dimensions, StatusBar} from 'react-native';
import {isAndroid} from './mixins';

const {width, height} = Dimensions.get('window');

const scaleWidth = (size: number) => (width / guidelineBaseWidth) * size;
const scaleHeight = (size: number) => (height / guidelineBaseHeight) * size;

// Guideline sizes are based on iPhone X / iPhone 11 Pro
const guidelineBaseWidth = 375;
const guidelineBaseHeight = 812;

// https://github.com/himelbrand/react-native-pixel-perfect
const cache = {};
const CURRENT_RESOLUTION = Math.sqrt(height * height + width * width);
export const create = (designSize = {width: 375, height: 812}) => {
  if (
    !designSize ||
    !designSize.width ||
    !designSize.height ||
    typeof designSize.width !== 'number' ||
    typeof designSize.height !== 'number'
  ) {
    throw new Error(
      'react-native-pixel-perfect | create function | Invalid design size object! must have width and height fields of type Number.',
    );
  }
  const DESIGN_RESOLUTION = Math.sqrt(
    designSize.height * designSize.height + designSize.width * designSize.width,
  );
  const RESOLUTIONS_PROPORTION = CURRENT_RESOLUTION / DESIGN_RESOLUTION;

  return (size: number) => {
    if (size in cache) return cache[size];
    else {
      cache[size] = RESOLUTIONS_PROPORTION * size;
      return cache[size];
    }
  };
};

export const perfectSize: (size: number) => number = create({
  width: 375,
  height: 812,
});

const space = 8;

const headerHight =
  perfectSize(90) - (isAndroid ? StatusBar.currentHeight || 0 : 0);
export default {
  none: 0,
  xs: perfectSize(space / 2),
  s: perfectSize(space),
  m: perfectSize(space * 2),
  l: perfectSize(space * 3),
  xl: perfectSize(space * 4),
  xxl: perfectSize(space * 5),
  xxxl: perfectSize(space * 6),
  header: perfectSize(space * 3),
  bottom: perfectSize(32),
  horizontal: perfectSize(20),
  scaleWidth,
  scaleHeight,
  headerHight,
};
