list = getList("image.titles");

selectImage(list[0]);
run("Set Scale...", "distance=9.7674 known=1 unit=micron");
run("Scale Bar...", "width=10 height=10 thickness=6 font=20 bold overlay");


selectImage(list[1]);
run("Set Scale...", "distance=9.7674 known=1 unit=micron");
run("Scale Bar...", "width=10 height=10 thickness=6 font=20 bold overlay");



selectImage(list[0]);
roiManager("Select", 0);
run("Crop");
selectImage(list[1]);
roiManager("Select", 0);
run("Crop");

waitForUser("Select neurite");

for (i = 0; i < list.length; i++) {
    selectImage(list[i]); 
    roiManager("Select", 1);
    run("Straighten...");
}
list = getList("image.titles");
selectImage(list[2]);

run("Find Maxima...", "prominence=30 output=[Point Selection]");
run("Measure");


function getUniqueFilename(basePath, baseName, extension) {
    // Initialize the unique filename with the base name and extension
    uniqueFilename = baseName + extension;
    fullPath = basePath + uniqueFilename;

    // Counter for generating new filenames
    counter = 1;

    // Check if file exists and generate a new filename if necessary
    while (File.exists(fullPath)) {
        uniqueFilename = baseName + "_" + counter + extension;
        fullPath = basePath + uniqueFilename;
        counter++;
    }

    return uniqueFilename;
}

// Retrieve the title of the image (assuming list is an array of image titles)
imageTitle = list[1];  // Replace with the correct index if needed

// Replace spaces or illegal characters in the title (optional)
imageTitle = replace(imageTitle, " ", "_");
imageTitle = replace(imageTitle, ":", "-");

// Define the base path and file extension
basePath = "C:/Users/keesd/Documents/Neuroscience and Cognition/Internship - Kenna lab/Lab/Analysis/Colocalization/mutants/";
baseName = "Results_" + imageTitle;
fileExtension = ".csv";

// Get a unique filename
uniqueFilename = getUniqueFilename(basePath, baseName, fileExtension);

// Construct the full file path for saving the results
savePath = basePath + uniqueFilename;

// Save the Results Table with the dynamically generated file name
saveAs("Results", savePath);

run("Clear Results");

selectImage(list[3]);

run("Find Maxima...", "prominence=25 output=[Point Selection]");
run("Measure");


function getUniqueFilename(basePath, baseName, extension) {
    // Initialize the unique filename with the base name and extension
    uniqueFilename = baseName + extension;
    fullPath = basePath + uniqueFilename;

    // Counter for generating new filenames
    counter = 1;

    // Check if file exists and generate a new filename if necessary
    while (File.exists(fullPath)) {
        uniqueFilename = baseName + "_" + counter + extension;
        fullPath = basePath + uniqueFilename;
        counter++;
    }

    return uniqueFilename;
}

// Retrieve the title of the image (assuming list is an array of image titles)
imageTitle = list[1];  // Replace with the correct index if needed

// Replace spaces or illegal characters in the title (optional)
imageTitle = replace(imageTitle, " ", "_");
imageTitle = replace(imageTitle, ":", "-");

// Define the base path and file extension
basePath = "C:/Users/keesd/Documents/Neuroscience and Cognition/Internship - Kenna lab/Lab/Analysis/Colocalization/mutants";
baseName = "Results_" + imageTitle;
fileExtension = ".csv";

// Get a unique filename
uniqueFilename = getUniqueFilename(basePath, baseName, fileExtension);

// Construct the full file path for saving the results
savePath = basePath + uniqueFilename;

// Save the Results Table with the dynamically generated file name
saveAs("Results", savePath);

run("Clear Results");
roiManager("Delete");
selectImage(list[2]);
run("16-bit");
selectImage(list[3]);
run("16-bit");