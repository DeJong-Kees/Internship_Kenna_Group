//crop all channels
roiManager("Select", 0);
roiManager("Rename", "crop");

list = getList("image.titles");
for (i = 0; i < list.length; i++) {
    selectImage(list[i]); 
    roiManager("Select", 0);
    run("Crop");
}

// add the color threshold
waitForUser("Please add region of interests and click OK to continue. 1 = nucleus; 2 = soma; 3 = neurites; 4 = protein presence");

//makes a ROI based on where fluorescence is present
//makes a nucleus, perinuclear, protein presense ROI
list = getList("image.titles");

roiManager("Select", 1);
roiManager("Rename", "nuclues");

roiManager("Select", 2);
roiManager("Rename", "soma");

roiManager("Select", 3);
roiManager("Rename", "neurites");

roiManager("Select", 4);
roiManager("Rename", "protein_presence");


// Function to delete ROIs from a specific index to the end
function deleteROIsFromIndex(startIndex) {
    roiManager("Deselect");  // Deselect all ROIs first

// Get the total number of ROIs in the ROI Manager
roiCount = roiManager("Count");

// Check if the start index is within the range
    if (startIndex >= roiCount) {
        print("Start index is greater than or equal to the number of ROIs.");
        return;
    }

// Loop through ROIs from the end to the start index and delete them
    for (i = roiCount - 1; i >= startIndex; i--) {
        roiManager("Select", i);
        roiManager("Delete");
    }
}



deleteROIsFromIndex(5);


//create the perinuclear area by distracting the nucleus from the soma
selectImage(list[0]);
roiManager("Select", 1); 
roiManager("Select", newArray(1,2)); 	//select nucleus and soma
roiManager("XOR"); 						//distracts the nucleus from the soma
roiManager("Add"); 						//add a new ROI, which is the perinuclear area
roiManager("Select", 2);
roiManager("Rename", "soma");
roiManager("Select", 2);
roiManager("Delete"); 					//delete the soma ROI
roiManager("Select", 1);
roiManager("Rename", "nucleus");
roiManager("Select", 4);
roiManager("Rename", "perinuclear");




//makes ROI where overlap is between protein presense and a ROI.
selectImage(list[1]);
roiManager("Select", 3);
roiManager("Select", newArray(3,4));	//select the perinuclear area and the localization of the protein
roiManager("AND"); 						//selects the regions where there is overlap
roiManager("Add"); 						//creates a new ROI
roiManager("Select", 5);
roiManager("Rename", "overlap_perinuclear");
roiManager("Select", 1);
roiManager("Select", newArray(1,3));
roiManager("AND");
roiManager("Add");
roiManager("Select", 6);
roiManager("Rename", "overlap_nucleus");
roiManager("Select", newArray(2,3));
roiManager("AND");
roiManager("Add");
roiManager("Select", 7);
roiManager("Rename", "overlap_neurites");

waitForUser("Please add region of interests and click OK to continue. 1 = nucleus; 2 = soma; 3 = neurites; 4 = protein presence");

roiManager("Select", 1);
run("Measure"); 						//measure the area of the nucleus
roiManager("Select", 6);
run("Measure"); 						//measures the overlap area between protein localization and the nucleus
roiManager("Select", 4);
run("Measure");							//measures the area of the perinuclear area
roiManager("Select", 5);
run("Measure"); 						//measures the overlap area between protein localization and perinuclear zone
roiManager("Select", 2);
run("Measure");							//measures the area of the neurites
roiManager("Select", 7);
run("Measure");							//measures the overlap area between protein localization and the neurites
roiManager("Select", 3);
run("Measure");							//measures the total area of the protein presense

//change to R


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
basePath = "C:/Users/keesd/Documents/Neuroscience and Cognition/Internship - Kenna lab/Lab/Analysis/Localization_12Sep2024/KIF5A_EX27/";
baseName = "Results_" + imageTitle;
fileExtension = ".csv";

// Get a unique filename
uniqueFilename = getUniqueFilename(basePath, baseName, fileExtension);

// Construct the full file path for saving the results
savePath = basePath + uniqueFilename;

// Save the Results Table with the dynamically generated file name
saveAs("Results", savePath);
Table.deleteRows(0, 7);

waitForUser("Please add region of interests and click OK to continue. 1 = nucleus; 2 = soma; 3 = neurites; 4 = protein presence");

roiManager("Select", 0);
roiManager("Select", newArray(0,1));
roiManager("Select", newArray(0,1,2));
roiManager("Select", newArray(0,1,2,3));
roiManager("Select", newArray(0,1,2,3,4));
roiManager("Select", newArray(0,1,2,3,4,5));
roiManager("Select", newArray(0,1,2,3,4,5,6));
roiManager("Select", newArray(0,1,2,3,4,5,6,7));
roiManager("Delete");