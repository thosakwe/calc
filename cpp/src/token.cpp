#include "token.h"

Token::Token(TokenType type, char* text) {
    this->type = type;
    this->text = text;
}

TokenType Token::getType() {
    return type;
}

char* Token::getText() {
    return text;
}