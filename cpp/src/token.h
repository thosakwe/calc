#ifndef H_TOKEN
#define H_TOKEN
#include "token_type.h"

class Token
{
  private:
    TokenType type;
    char *text;

  public:
    Token(TokenType, char*);
    TokenType getType();
    char* getText();
};

#endif