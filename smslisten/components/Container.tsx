import React from 'react';
import {SafeAreaView} from 'react-native-safe-area-context';
import styled from 'styled-components/native';
import {perfectSize} from '../styles/spacing';

export default ({children}) => {
  return (
    <SafeAreaView>
      <Container>{children}</Container>
    </SafeAreaView>
  );
};

const Container = styled.View`
  margin: ${perfectSize(20)}px;
`;
