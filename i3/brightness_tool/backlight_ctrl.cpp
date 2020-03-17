#include <iostream>
#include <fstream>
#include <cstring>

#define MIN_VALUE 0
#define MAX_VALUE 100000
#define INC_VALUE 2500
#define FILE_NAME "/sys/class/backlight/intel_backlight/brightness"

void help(char *call_cmd) {
    std::cout << "Usage: " << call_cmd << " -u/-d to increase/decrease brightness" << std::endl;
}

void fatal(char *call_cmd, char *error_msg) {
    std::cout << "[!!] FATAL ERROR: " << error_msg << "\nExiting" << std::endl;
    help(call_cmd);
    exit(0);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fatal(argv[0], (char *) "No input provided");
    }
    int delta = strcmp(argv[1], "-u") == 0 ? 1 : (strcmp(argv[1], "-d") == 0 ? -1 : 0);
    if (delta == 0)
        fatal(argv[0], (char *) "Invalid input provided");

    std::fstream ctrl_file;
    ctrl_file.open(FILE_NAME, std::ios::in);
    std::string cur_brightness;
    ctrl_file >> cur_brightness;
    int i_cur_brightness = std::stoi(cur_brightness);
    ctrl_file.close();

    if (delta == 1)
        i_cur_brightness += INC_VALUE;
    else
        i_cur_brightness -= INC_VALUE;

    if (i_cur_brightness > MAX_VALUE)
        i_cur_brightness = MAX_VALUE;
    if (i_cur_brightness < MIN_VALUE)
        i_cur_brightness = MIN_VALUE;

    ctrl_file.open(FILE_NAME, std::ios::out | std::ios::trunc);
    ctrl_file << i_cur_brightness;
    ctrl_file.close();
}