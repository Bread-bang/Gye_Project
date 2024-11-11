module.exports = {
  networks: {
    development: {
      host: "127.0.0.1", // 로컬 개발용 서버 주소 (Ganache)
      port: 7545, // Ganache의 기본 포트
      network_id: "*", // 모든 네트워크 ID와 일치
    },
  },
  compilers: {
    solc: {
      version: "0.8.0", // Solidity 컴파일러 버전 (사용 중인 버전에 맞춰 조정)
    },
  },
};
