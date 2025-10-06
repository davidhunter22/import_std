import std;

// #include <iostream>
// #include <print>

int main(int argc, char* argv[])
{
	// This should fail to compile
    // uint32_t i = 0;

    std::filesystem::path p;

    std::cout << p.stem( ) << std::endl;

    std::println( "Hello world!" );
    return 0;
}
