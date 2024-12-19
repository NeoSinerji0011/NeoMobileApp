import React from 'react';
import {StyleProp, Text as RNText, TextProps, TextStyle} from 'react-native';
interface IProps extends TextProps {
  type?: StyleProp<TextStyle>;
  children?: string | number | JSX.Element | JSX.Element[];
}

export default ({children, ...attrs}: IProps) => {
  return (
    <RNText allowFontScaling={false} {...attrs}>
      {children}
    </RNText>
  );
};
