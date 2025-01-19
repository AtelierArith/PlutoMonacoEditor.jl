import numpy as np


def my_api():
    return np.random.random((3, 4))


def main():
    print("Hello Python")
    x = my_api()
    print(f"{x=}")


if __name__ == "__main__":
    main()
    