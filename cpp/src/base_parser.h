#ifndef H_BASE_PARSER
#define H_BASE_PARSER
#include <vector>
#include "token_type.h"
#include "token.h"
using namespace std;

class BaseParser
{
  private:
    int index;
    vector<Token*>* tokens;

  public:
    BaseParser(vector<Token*>*);
    Token *peek();
    Token *consume();
    bool isDone();
    bool next(TokenType);
};

#endif