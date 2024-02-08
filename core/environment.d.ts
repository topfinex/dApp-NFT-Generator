declare global {
    namespace NodeJS {
        interface ProcessEnv {
            YOUR_INFURA_PROJECT_ID: string;
            GITHUB_AUTH_TOKEN: string;
            NODE_ENV: 'development';
            PORT?: string;
            PWD: string;
        }
    }
}

export { }