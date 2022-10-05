module.exports = {
  networks: {  
    development: {
     host: "192.168.43.20",     // Localhost (default: none)
     port: 7545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
    advanced: {
      WebSockets: true,
    }},  
  contracts_build_directory: "./src/abis/",
  compilers: {
    solc: {
      version: "0.8.17",     
      settings: {          
       optimizer: {
         enabled: false,
         runs: 200
       },
      }
    }
  },
};