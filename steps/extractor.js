const fs = require('fs');

const metadata = {
    "name": "Example NFT",
    "description": "This is an example NFT",
    "image": "https://example.com/image.jpg",
    "attributes": [
        {"trait_type": "Color", "value": "Blue"},
        {"trait_type": "Size", "value": "Medium"}
    ]
};

const metadataJSON = JSON.stringify(metadata, null, 2);

fs.writeFileSync('metadata.json', metadataJSON);

console.log('Metadata saved to metadata.json');