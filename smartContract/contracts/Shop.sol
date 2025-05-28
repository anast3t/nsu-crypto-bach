pragma solidity >=0.4.25 <0.9.0;

contract Shop {
    event LogNewAlert(string description);

    uint public currProdId = 0;
    function getProdId() private returns (uint) {
        return currProdId++;
    }

    struct Product {
        uint productId;
        string productName;
        uint256 price;
        address payable seller;
    }

    struct Deal {
        uint productId;
        address buyer;
    }

    mapping(uint => Product) products;
    Product[] public allProducts;

    mapping(address => Deal[]) deals;
    // mapping(address => Product[]) placed;

    function addProduct(
        string memory _productName,
        uint256 _price
    ) public returns (Product memory) {
        uint newID = getProdId();
        Product memory newProduct = Product(
            newID,
            _productName,
            _price,
            payable(msg.sender)
        );

        products[newID] = newProduct;
        // placed[msg.sender] = 

        allProducts.push(newProduct);

        return newProduct;
    }

    function buyProduct(uint _productId) payable public returns (Deal memory) {
        

        require(msg.value == products[_productId].price, "Value Must be Equal to Price of Product");
        address payable seller = products[_productId].seller;

        bool sent = seller.send(msg.value);
        require(sent, "Failed to send Ether");

        Deal memory newDeal = Deal (_productId, msg.sender);

        deals[msg.sender].push(newDeal);
        deals[seller].push(newDeal);

        return newDeal;
    }

    function getProducts() public view returns (Product[] memory) {
        return allProducts;
    }
}
