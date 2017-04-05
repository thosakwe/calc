#include "scan.h"

int scanInt(int i, long len, string* s, const char *str) {
    int count = 0;

    for (int j = i; j < len; j++)
    {
        char peek = str[j];

        if (isnumber(peek))
        {
            s += peek;
            count++;
        }
    }

    return count;
}

/**
 * Leading-dot
 * @example .5
 */
int scanDotDecimal(int i, long len, string* s, const char *str)
{
    int count = 0;

    // Maybe decimal
    char cur = str[i];

    if (cur == '.' && i < len - 1 && isnumber(str[i + 1]))
    {
        (*s) += cur;

        for (int j = i + 1; j < len; j++)
        {
            char peek = str[j];

            if (isnumber(peek))
            {
                (*s) += peek;
                count++;
            }
        }
    }

    return count;
}

int scanPositive(int i, long len, string* s, const char *str) {
    char ch = str[i];
    int count = 0;

    if (isnumber(ch))
    {
        int num = scanInt(i, len, s, str);

        if (num > 0) {
            num += scanDotDecimal(i + num, len, s, str);
            count += num;
        }
    } else if (ch == '.' && i < len - 1) {
        count += scanDotDecimal(i, len, s, str);
    }

    return count;
}

int scanNumber(int i, long len, string* s, const char *str) {
    char ch = str[i];
    int count = 0;

    if (ch == '-' && i < len - 1 && (isnumber(str[i + 1]) || (i < len - 2 && str[i + 1] == '.' && isnumber(str[i + 2]))))
    {
        (*s) += '-';
        count += scanPositive(i + 1, len, s, str);
    }

    if (isnumber(ch) || (ch == '.' && i < len - 1))
    {
        return scanPositive(i, len, s, str);
    }

    return count;
}

void scan(vector<Token *> *tokens, string source)
{
    const char *str = source.c_str();
    long len = source.length();

    for (long i = 0; i < len; i++)
    {
        vector<Token *> potential;
        char ch = str[i];

        #if(DEBUG)
        cout << "i: " << i << ", ch: " << ch << endl;
        #endif

        if (ch == '(')
            potential.push_back(new Token(LPAREN, &ch));
        if (ch == ')')
            potential.push_back(new Token(RPAREN, &ch));
        if (ch == '^')
            potential.push_back(new Token(CARET, &ch));
        if (ch == '*')
            potential.push_back(new Token(ASTERISK, &ch));
        if (ch == '/')
            potential.push_back(new Token(SLASH, &ch));
        if (ch == '+')
            potential.push_back(new Token(PLUS, &ch));
        if (ch == '-')
            potential.push_back(new Token(MINUS, &ch));

        if (isnumber(ch) || ch == '.' || ch == '-')
        {
            string s;
            int num = scanNumber(i, len, &s, str);

            if (num > 0) {
                potential.push_back(new Token(NUMBER, (char*) s.c_str()));
            }
        }

        long pSize = potential.size();
        #if(DEBUG)
        cout << "pSize: " << pSize << endl;

        for (long i = 0; i < pSize; i++) {
            Token *token = potential.at(i);
            cout << " * Token #" << i + 1 << ": " << (long) (token->getText()) << endl;
        }
        #endif

        if (pSize > 0) {
            Token *longest;
            size_t longestLen = 0;

            for (long i = 0; i < pSize; i++) {
                Token *token = potential.at(i);
                size_t tLen = strlen(token->getText());

                if (tLen > longestLen) {
                    longest = token;
                    longestLen = tLen;
                }
            }

            tokens->push_back(longest);
            i += strlen(longest->getText());
        }
    }
}