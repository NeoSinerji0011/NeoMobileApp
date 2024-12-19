import {Inset, Row} from '@muratoner/semantic-ui-react-native';
import React from 'react';
import styled from 'styled-components/native';
import spacing from '../styles/spacing';
import FontAwesome from 'react-native-vector-icons/FontAwesome';
import Text from './Text';
import {Colors} from '../styles';

interface IProps {
  text?: string;
  show?: boolean;
}

export default ({text, show}: IProps) => {
  return show && text ? (
    <ValidationError>
      <FontAwesome
        name="warning"
        size={16}
        color={Colors.STATUS_VALIDATION_ERROR}
      />
      <Inset left={spacing.s}>
        <Text>{text}</Text>
      </Inset>
    </ValidationError>
  ) : null;
};

const ValidationError = styled(Row)`
  align-items: center;
  margin-top: ${spacing.xs}px;
  margin-bottom: ${spacing.xs}px;
`;
