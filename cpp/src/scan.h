#ifndef H_SCAN
#define H_SCAN
#include <cstring>
#include <cctype>
#if(DEBUG)
#include <iostream>
#endif
#include <string>
#include <vector>
#include "token_type.h"
#include "token.h"
using namespace std;

void scan(vector<Token*>* tokens, string source);

#endif