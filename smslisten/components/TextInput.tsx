import {Stack} from '@muratoner/semantic-ui-react-native';
import React, {createRef, useState} from 'react';
import {
  Keyboard,
  Pressable,
  Text,
  TextInput as RNTextInput,
  TextInputProps,
} from 'react-native';
import styled from 'styled-components';
import {Colors, Spacing} from '../styles';
import spacing, {perfectSize} from '../styles/spacing';
import ErrorText from './ErrorText';

export interface ITextInputProps extends TextInputProps {
  value: string;
  placeholder: string;
  editable?: boolean;
  error?: any;
  errorText?: string;
  autoFocus?: boolean;
  inputBackgroundColor?: string;
}

export default ({
  value,
  placeholder,
  editable = true,
  error,
  errorText,
  autoFocus,
  inputBackgroundColor = 'white',
  ...props
}: ITextInputProps) => {
  const [showError, setShowError] = useState(false);
  const textInputRef = createRef<RNTextInput>();

  const onPressTextInput = () => {
    if (textInputRef && textInputRef.current !== null) {
      textInputRef?.current.focus();
    }
  };

  const onEndEditing = () => {
    setShowError(Boolean(error));
  };

  const onChange = () => {
    if (showError) {
      setShowError(Boolean(error));
    }
  };

  return (
    <>
      <TextInputContainer
        onPress={onPressTextInput}
        error={showError}
        editable={editable}
        inputBackgroundColor={editable ? inputBackgroundColor : '#DCDCDC'}>
        <Text>{placeholder}</Text>

        <Stack size={spacing.s} />

        <StyledRNTextInput
          {...props}
          value={value}
          blurOnSubmit
          underlineColorAndroid="transparent"
          pointerEvents={'auto'}
          returnKeyType={'done'}
          editable={editable}
          ref={textInputRef}
          onEndEditing={onEndEditing}
          onChange={onChange}
          autoFocus={autoFocus}
          onSubmitEditing={Keyboard.dismiss}
        />
      </TextInputContainer>
      <ErrorText show={showError} text={errorText} />
    </>
  );
};

const TextInputContainer = styled(Pressable)<{
  editable: boolean;
  inputBackgroundColor: string;
  error?: boolean;
}>`
  height: ${perfectSize(64)}px;
  border-width: ${({error}) => (error ? 2 : 1)}px;
  border-radius: 5px;
  align-items: flex-start;
  border-color: ${({error}) =>
    error ? Colors.STATUS_VALIDATION_ERROR : Colors.GRAY_GRAY_1};
  padding: ${Spacing.s}px ${Spacing.m}px;
  justify-content: center;
  background-color: ${({inputBackgroundColor}) =>
    inputBackgroundColor ? inputBackgroundColor : 'transparent'};
`;

const StyledRNTextInput = styled(RNTextInput)`
  flex: 1;
  width: 100%;
  font-family: Gilroy-Medium;
  color: ${Colors.GRAY_GRAY_DARK_1};
  font-size: ${perfectSize(15)}px;
  padding-top: 0;
  padding-bottom: 0;
`;
