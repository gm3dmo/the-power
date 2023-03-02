# Dog Bone Tracker

## Description

Dog Bone Tracker is a software package designed to help dog owners keep track of their dog's bones. It allows the user to create a list of their dog's bones, record the number of bones the dog has, and keep track of when bones have been given to the dog.

## Features

- Create a list of the dog's bones
- Record the number of bones the dog has
- Keep track of when bones have been given to the dog
- Mark bones as given or not given
- View a history of bones given to the dog

## Installation

To install Dog Bone Tracker, follow these steps:

1. Clone the repository to your local machine.
    
2. Navigate to the root directory of the project.
    
3. Run the following command to install the required dependencies:
    
    Copy code
    
    `npm install` 
    
4. Start the application with the following command:
    
    sqlCopy code
    
    `npm start` 
    

## ER Diagram
This is a fancy diagram explaining this:
```mermaid
erDiagram
          DOG }|..|{ PAW-PRINT : has
          DOG ||--o{ VERIFICATION : places
          DOG ||--o{ IDENTITY-VERIFICATION : "liable for"
          PAW-PRINT ||--o{ VERIFICATION : receives
          IDENTITY-VERIFICATION ||--|{ VERIFICATION : covers
          VERIFICATION ||--|{ VERIFICATION-ITEM : includes
          DOG-BREED ||--|{ BREED : contains
          BREED ||--o{ VERIFICATION-ITEM : "ordered in"
```


## Usage

Once the application is running, open your web browser and navigate to `http://localhost:3000` to access the Dog Bone Tracker application.

To add a bone, click the "Add Bone" button and fill out the form. To give a bone to the dog, click the "Give Bone" button next to the bone you want to give. To view the history of bones given to the dog, click the "History" button.

## Contributing

If you would like to contribute to Dog Bone Tracker, please follow these guidelines:

1. Fork the repository and create a new branch for your feature.
2. Write tests for your feature.
3. Write your feature.
4. Ensure that all tests pass.
5. Submit a pull request.

## License

Dog Bone Tracker is licensed under the MIT License.
