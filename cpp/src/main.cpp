#include <iostream>
#include <string>
// #include "expression.h"
// #include "parser.h"
#include "scan.h"
using namespace std;

int main(int argc, char** argv) {
    #if(DEBUG)
    cout << "RUNNING DEBUG" << endl;
    #endif

    string line;

    while (true) {
        cout << "Enter an equation: ";
        cin >> line;
        vector<Token*> tokens;
        scan(&tokens, line);

        long tLen = tokens.size();
        cout << tLen << " token(s):" << endl;

        for (long i = 0; i < tLen; i++) {
            Token *token = tokens.at(i);
            cout << " * Token #" << i + 1 << ": " << token->getText() << endl;
        }

        /* Parser *parser = new Parser(&tokens);
        Expression *expression = parser->parseExpression();
        double result = expression->solve();
        cout << "Result: " << result << endl;
        */
    }

    return 0;
}