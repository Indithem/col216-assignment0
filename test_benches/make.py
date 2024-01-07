TEST_CASES=500
FILE="cases.txt"

# create a list of a tuple with two unsigned numbers from 0 to 65535, no repeatation of tuples
# order of the tuple does not matter
# size of the tuple is N
def make_cases():
    import random
    cases = set()
    while len(cases) < TEST_CASES:
        cases.add(tuple(sorted(random.sample(range(65536), 2))))
    return cases

if __name__ == "__main__":
    cases=make_cases()
    # calculate product of all elements in the tuple
    product = [x*y for x,y in cases]

    # write to file
    with open(FILE, "w") as f:
        for i,case in enumerate(cases):
            f.write("{} {} {}\n".format(case[0], case[1], product[i]))
        