import React from 'react';
import {ViewStyle} from 'react-native';
import styled from 'styled-components/native';
import {perfectSize} from '../styles/spacing';

interface IProps {
  flex?: number;
  disabled?: boolean;
  noPadding?: boolean;
  children: React.ReactNode | React.ReactNode[];
  style?: ViewStyle;
  borderRadius?: number;
  hasShadow?: boolean;
  disableShadowMargin?: boolean;
}

export default ({
  noPadding = false,
  children,
  hasShadow = true,
  disableShadowMargin = false,
  ...props
}: IProps) => {
  return (
    <Container
      {...props}
      noPadding={noPadding}
      hasShadow={hasShadow}
      disableShadowMargin={disableShadowMargin}>
      {children}
    </Container>
  );
};

const Container = styled.View<{
  noPadding?: boolean;
  flex?: number;
  disabled?: boolean;
  hasShadow?: boolean;
  borderRadius?: number;
  disableShadowMargin?: boolean;
}>`
  ${({flex}) => (flex ? `flex: ${flex}` : '')}
  background-color: ${({disabled}) => (disabled ? '#DCDCDC' : 'white')};
  padding: ${({noPadding}) => (!noPadding ? `${perfectSize(16)}px` : '0')};
  border-radius: ${({borderRadius}) => borderRadius || 8}px;
  ${({hasShadow}) => hasShadow && 'box-shadow: 0 2px 4px black'};
  ${({hasShadow}) => hasShadow && 'shadow-opacity: 0.12'};
  ${({hasShadow}) => hasShadow && 'elevation: 4'};
  ${({hasShadow}) => !hasShadow && 'border-width: 1px'};
  ${({hasShadow}) => !hasShadow && 'border-color: #DCDCDC'};
  margin-bottom: ${({disableShadowMargin}) => (disableShadowMargin ? 0 : 3)}px;
`;
