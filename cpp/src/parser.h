#ifndef H_PARSER
#define H_PARSER
#include <stack>
#include "base_parser.h"
#include "expression.h"
using namespace std;

class Parser : public BaseParser
{
  private:
    stack<Token*> shunt;

  public:
    Parser(vector<Token*>* tokens);
    Expression* parseExpression();
};

#endif