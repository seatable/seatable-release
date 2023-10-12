import os
import re
import yaml
import argparse


def main():
    # Define the command line argument
    parser = argparse.ArgumentParser()
    parser.add_argument("-images", action="store_true", help="Filter output for IMAGE")
    args = parser.parse_args()

    # Define the path to the release folder
    release_folder = "compose/"

    # Loop through all .yml files in the release folder
    for filename in os.listdir(release_folder):
        if filename.endswith(".yml"):

            # Print the filenames
            print(f"--- {os.path.join(release_folder, filename)} ---")

            # Open the file and load the YAML data
            with open(os.path.join(release_folder, filename), "r") as f:
                yaml_data = yaml.safe_load(f)

            # Convert the YAML data to a string
            yaml_string = yaml.dump(yaml_data)

            # Define the regex pattern
            pattern = r"\${.*?}"

            # Search for the pattern in the YAML string
            matches = re.findall(pattern, yaml_string)

            # Join the matches into a single string with line breaks
            matches_string = "\n".join(matches)

            # Filter the output for "IMAGE" if the "-images" argument is present
            if args.images:
                matches_string = "\n".join([line for line in matches_string.split("\n") if "IMAGE" in line])

            # Print the matches as separate lines
            print(matches_string)

            print()


if __name__ == "__main__":
    main()